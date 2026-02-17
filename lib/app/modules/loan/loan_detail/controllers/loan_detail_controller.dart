import 'package:get/get.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/models/meeting.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';
import 'package:plug/app/utils/logger.dart';
import 'package:plug/app/utils/role_utils.dart';
import 'package:plug/app/routes/app_pages.dart';

class LoanDetailController extends GetxController {
  final api = Get.find<ApiClient>();
  late final ChatService chat = ChatService(api);
  late final MeetingService meetingService = MeetingService(api);

  final loan = Rxn<Loan>();
  final isPaying = false.obs;
  final meeting = Rxn<Meeting>();

  bool get isAccepted => (loan.value?.status.name ?? '') == 'ACCEPTED';
  bool get isPaid => (loan.value?.status.name ?? '') == 'PAID';
  bool get isWaitingForReturn =>
      (loan.value?.status.name ?? '') == 'WAITING_FOR_RETURN';
  bool get isPending => (loan.value?.status.name ?? '') == 'PENDING';
  bool get isCompleted => (loan.value?.status.name ?? '') == 'COMPLETED';
  bool get meetingAccepted => (meeting.value?.status.name ?? '') == 'ACCEPTED';

  @override
  void onInit() {
    super.onInit();
    loan.value = Loan.fromJson(Get.arguments?['loan'] ?? {});
    _loadMeeting();
  }

  Future<void> _loadMeeting() async {
    final loanId = loan.value?.id ?? '';
    if (loanId.isEmpty) return;
    try {
      final m = await meetingService.getMeeting(loanId);
      meeting.value = m;
      logInfo('Meeting loaded for $loanId', tag: 'LoanDetail');
    } catch (_) {}
  }

  Future<void> pay() async {
    if (!isAccepted) {
      Get.snackbar('Info', 'Menunggu persetujuan lender terlebih dahulu.');
      return;
    }
    if (!RoleUtils.isBorrower()) {
      Get.snackbar('Info', 'Hanya borrower yang dapat melakukan pembayaran.');
      return;
    }

    isPaying.value = true;
    try {
      final loanId = loan.value?.id ?? '';
      await api.private.post('/payment/pay', data: {'loanId': loanId});

      final current = loan.value!.toJson();
      current['status'] = 'PAID';
      loan.value = Loan.fromJson(current);

      Get.snackbar('Sukses', 'Pembayaran berhasil');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isPaying.value = false;
    }
  }

  Future<void> showQr() async {
    if (!isPaid || !meetingAccepted) {
      Get.snackbar(
        'Info',
        'QR tersedia setelah pembayaran dan lokasi disetujui.',
      );
      return;
    }
    final loanId = loan.value?.id ?? '';
    if (loanId.isEmpty) return;
    Get.toNamed(Routes.QR, parameters: {'loanId': loanId});
  }

  Future<void> scanQr() async {
    if (!isPaid || !meetingAccepted) {
      Get.snackbar(
        'Info',
        'Scan tersedia setelah pembayaran dan lokasi disetujui.',
      );
      return;
    }
    final loanId = loan.value?.id ?? '';
    if (loanId.isEmpty) return;

    final result = await Get.toNamed(
      Routes.QR_SCAN,
      parameters: {'loanId': loanId},
    );
    if (result == true) {
      final current = loan.value!.toJson();
      current['status'] = 'WAITING_FOR_RETURN';
      loan.value = Loan.fromJson(current);

      await _loadMeeting();
      Get.snackbar('Sukses', 'Menunggu pengembalian barang');
    }
  }

  Future<void> chats() async {
    if (isCompleted) {
      Get.snackbar('Info', 'Transaksi selesai, chat ditutup');
      return;
    }
    if (!isPaid) {
      Get.snackbar('Info', 'Silakan bayar terlebih dahulu.');
      return;
    }
    try {
      final lenderId = loan.value!.lenderId;
      final borrowerId = loan.value!.borrowerId;
      final productId = loan.value!.productId;
      final loanId = loan.value!.id;
      final otherId = RoleUtils.isBorrower() ? lenderId : borrowerId;

      final room = await chat.ensureRoom(otherId, productId: productId);
      final roomId = room['id'] ?? room['roomId'];

      Get.toNamed(
        Routes.CHAT,
        parameters: {'roomId': '$roomId', 'otherId': otherId, 'loanId': loanId},
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> markReturned() async {
    final id = loan.value?.id ?? '';
    if (id.isEmpty) return;
    try {
      final res = await api.private.patch('/loan/$id/returned');
      loan.value = Loan.fromJson(Map<String, dynamic>.from(res.data['data']));
      Get.snackbar('Selesai', 'Barang sudah kembali, chat ditutup');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }
}
