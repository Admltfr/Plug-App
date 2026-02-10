import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/payment_service.dart';
import 'package:plug/app/data/network/services/chat_service.dart';

class LoanDetailController extends GetxController {
  final api = Get.find<ApiClient>();
  late final PaymentService payment = PaymentService(api);
  late final ChatService chat = ChatService(api);

  final loan = Rxn<Map<String, dynamic>>();
  final isPaying = false.obs;

  @override
  void onInit() {
    super.onInit();
    loan.value = (Get.arguments?['loan'] as Map<String, dynamic>?);
  }

  bool get isAccepted => (loan.value?['status'] ?? '') == 'ACCEPTED';
  bool get isPaid => (loan.value?['status'] ?? '') == 'PAID';
  String get lenderId => loan.value?['lender_id'] ?? '';
  String get productId => '${loan.value?['product_id']}';

  Future<void> pay() async {
    if (!isAccepted) {
      Get.snackbar('Info', 'Menunggu persetujuan lender terlebih dahulu.');
      return;
    }
    isPaying.value = true;
    try {
      final loanId = '${loan.value?['id']}';
      await payment.pay(loanId);
      Get.snackbar('Sukses', 'Pembayaran berhasil');
      final current = Map<String, dynamic>.from(loan.value!);
      current['status'] = 'PAID';
      loan.value = current;
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isPaying.value = false;
    }
  }

  Future<void> chats() async {
    if (!isPaid) {
      Get.snackbar('Info', 'Silakan bayar terlebih dahulu.');
      return;
    }
    try {
      final room = await chat.ensureRoom(lenderId, productId: productId);
      final roomId = room['id'] ?? room['roomId'];
      Get.toNamed(
        '/chat',
        parameters: {'roomId': '$roomId', 'otherId': lenderId},
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }
}
