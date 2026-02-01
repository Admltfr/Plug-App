import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/payment_service.dart';

class PaymentController extends GetxController {
  final api = Get.find<ApiClient>();
  late final PaymentService service = PaymentService(api);
  final lenderIdCtrl = TextEditingController();
  final amountCtrl = TextEditingController();
  final isSubmitting = false.obs;

  Future<void> submit() async {
    final lenderId = lenderIdCtrl.text.trim();
    final amt = num.tryParse(amountCtrl.text) ?? 0;
    if (lenderId.isEmpty || amt <= 0) {
      Get.snackbar('Gagal', 'Isi lenderId dan amount dengan benar');
      return;
    }
    isSubmitting.value = true;
    try {
      final r = await service.pay(lenderId, amt);
      Get.snackbar('Berhasil', 'Transfer: ${r.id}');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    lenderIdCtrl.dispose();
    amountCtrl.dispose();
    super.onClose();
  }
}
