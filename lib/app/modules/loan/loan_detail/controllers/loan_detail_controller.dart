import 'package:get/get.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/models/meeting.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';
import 'package:plug/app/data/network/services/payment_service.dart';
import 'package:plug/app/data/network/services/loan_service.dart';
import 'package:plug/app/utils/role_utils.dart';
import 'package:plug/app/routes/app_pages.dart';

class LoanDetailController extends GetxController {
  final api = Get.find<ApiClient>();
  late final ChatService chat = ChatService(api);
  late final MeetingService meetingService = MeetingService(api);
  late final PaymentService paymentService = PaymentService(api);
  late final LoanService loanService = LoanService(api);

  final loan = Rxn<Loan>();
  final isPaying = false.obs;
  final meeting = Rxn<Meeting>();

  bool get isAccepted => (loan.value?.status.name ?? '') == 'ACCEPTED';
  bool get isPaid => (loan.value?.status.name ?? '') == 'PAID';
  bool get isMeeting => (loan.value?.status.name ?? '') == 'MEETING';
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
      await paymentService.pay(loanId);

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
    if (!isMeeting || !meetingAccepted) {
      Get.snackbar(
        'Info',
        'QR tersedia saat loan MEETING dan lokasi disetujui.',
      );
      return;
    }
    final loanId = loan.value?.id ?? '';
    if (loanId.isEmpty) return;
    Get.toNamed(Routes.QR, parameters: {'loanId': loanId});
  }

  Future<void> scanQr() async {
    if (!isMeeting || !meetingAccepted) {
      Get.snackbar(
        'Info',
        'Scan tersedia saat loan MEETING dan lokasi disetujui.',
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

      try {
        final fresh = await loanService.getLoan(loanId);
        loan.value = fresh;
      } catch (_) {}

      Get.snackbar('Sukses', 'Menunggu pengembalian barang');
    }
  }

  Future<void> chats() async {
    if (isCompleted) {
      Get.snackbar('Info', 'Transaksi selesai, chat ditutup');
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

    if (!RoleUtils.isLender()) {
      Get.snackbar('Info', 'Hanya lender yang dapat menandai pengembalian.');
      return;
    }

    try {
      final fresh = await loanService.getLoan(id);
      loan.value = fresh;
    } catch (_) {}

    if (!isWaitingForReturn) {
      Get.snackbar('Info', 'Loan belum menunggu pengembalian.');
      return;
    }

    try {
      final updated = await loanService.markReturned(id);
      loan.value = updated;
      Get.snackbar('Selesai', 'Barang sudah kembali, chat ditutup');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> refreshLoan() async {
    final id = loan.value?.id ?? '';
    if (id.isEmpty) return;
    try {
      final fresh = await loanService.getLoan(id);
      loan.value = fresh;
      await _loadMeeting();
    } catch (_) {}
    await _loadMeeting();
  }
}
