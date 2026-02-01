import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/payment_controller.dart';

class PaymentView extends GetView<PaymentController> {
  const PaymentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Pay Lender')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: controller.lenderIdCtrl,
              decoration: const InputDecoration(labelText: 'Lender ID'),
            ),
            TextField(
              controller: controller.amountCtrl,
              decoration: const InputDecoration(labelText: 'Amount'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 12),
            Obx(
              () => ElevatedButton(
                onPressed:
                    controller.isSubmitting.value ? null : controller.submit,
                child: Text(
                  controller.isSubmitting.value ? 'Processing...' : 'Pay',
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
