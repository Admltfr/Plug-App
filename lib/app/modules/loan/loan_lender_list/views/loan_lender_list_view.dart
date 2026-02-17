import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loan_lender_list_controller.dart';

class LoanLenderListView extends GetView<LoanLenderListController> {
  const LoanLenderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peminjaman (Lender)')),
      body: SafeArea(
        child: Obx(() {
          final items = controller.items;
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          if (items.isEmpty) {
            return const Center(child: Text('Belum ada peminjaman'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemBuilder: (_, i) {
              final loan = items[i];
              final product = loan.product;
              final borrower = loan.borrower;
              return Card(
                elevation: 2,
                clipBehavior: Clip.antiAlias,
                child: InkWell(
                  onTap: () => controller.onTapLoan(loan),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          product?.name ?? '-',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Borrower: ${borrower?.name ?? ''} • Rp ${loan.amount}',
                          style: const TextStyle(fontSize: 12),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Status: ${loan.status.name}',
                          style: const TextStyle(fontSize: 12),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemCount: items.length,
          );
        }),
      ),
    );
  }
}
