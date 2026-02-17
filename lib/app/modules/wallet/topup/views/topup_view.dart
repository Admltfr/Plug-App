import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/topup_controller.dart';

class TopupView extends GetView<TopupController> {
  const TopupView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Topup Wallet')),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                controller: controller.amountValue,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Nominal',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: controller.createTopup,
                  icon: const Icon(Icons.payments),
                  label: const Text('Bayar via Midtrans'),
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'Setelah pembayaran selesai, kembali dan refresh saldo di Wallet.',
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
