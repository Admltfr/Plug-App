import 'package:get/get.dart';
import 'package:plug/app/data/models/wallet.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/payment_service.dart';

class WalletHomeController extends GetxController {
  final api = Get.find<ApiClient>();
  late final PaymentService service = PaymentService(api);
  final balance = 0.0.obs;
  final isLoading = false.obs;

  Future<void> refreshBalance() async {
    isLoading.value = true;
    try {
      final Wallet w = await service.balance();
      balance.value = w.balance;
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onInit() {
    super.onInit();
    refreshBalance();
  }
}
