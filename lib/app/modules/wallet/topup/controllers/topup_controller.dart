import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/payment_service.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:midtrans_sdk/midtrans_sdk.dart';

class TopupController extends GetxController {
  final api = Get.find<ApiClient>();
  late final PaymentService service = PaymentService(api);
  final amountValue = TextEditingController();
  MidtransSDK? _midtrans;

  Future<void> _initMidtrans() async {
    final clientKey = dotenv.env['MIDTRANS_CLIENT_KEY'] ?? '';
    final merchantBaseUrl = 'https://app.sandbox.midtrans.com/';

    if (clientKey.isEmpty) {
      throw Exception('MIDTRANS_CLIENT_KEY tidak terisi');
    }

    final config = MidtransConfig(
      clientKey: clientKey,
      merchantBaseUrl: merchantBaseUrl,
      language: 'id',
      enableLog: true,
    );

    _midtrans = await MidtransSDK.init(config: config);
  }

  Future<void> createTopup() async {
    final amount = num.tryParse(amountValue.text) ?? 0;
    if (amount <= 0) {
      Get.snackbar('Gagal', 'Nominal tidak valid');
      return;
    }

    final res = await service.topup(amount);
    final token = res['token'] as String?;
    if (token == null || token.isEmpty) {
      Get.snackbar('Gagal', 'Token Snap tidak tersedia');
      return;
    }

    try {
      if (_midtrans == null) {
        await _initMidtrans();
      }

      await _midtrans!.startPaymentUiFlow(token: token);

      Get.snackbar('Info', 'Top up dibuka. Setelah selesai, refresh saldo.');
    } catch (e) {
      Get.snackbar('Gagal', 'Tidak bisa memulai pembayaran: $e');
    }
  }

  @override
  void onClose() {
    amountValue.dispose();
    super.onClose();
  }
}
