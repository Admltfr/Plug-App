import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loan_detail_controller.dart';

class LoanDetailView extends GetView<LoanDetailController> {
  const LoanDetailView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Peminjaman')),
      body: Obx(() {
        final loan = controller.loan.value;
        if (loan == null)
          return const Center(child: Text('Loan tidak ditemukan'));
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Produk: ${loan['product']?['name'] ?? ''}'),
              const SizedBox(height: 8),
              Text('Jumlah: Rp ${loan['amount']}'),
              const SizedBox(height: 8),
              Text('Status: ${loan['status']}'),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed:
                          controller.isPaying.value
                              ? null
                              : (controller.isAccepted ? controller.pay : null),
                      child:
                          controller.isPaying.value
                              ? const SizedBox(
                                height: 20,
                                width: 20,
                                child: CircularProgressIndicator(),
                              )
                              : const Text('Bayar'),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: controller.isPaid ? controller.chats : null,
                      child: const Text('Chat'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      }),
    );
  }
}
