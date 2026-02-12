import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import '../controllers/loan_lender_list_controller.dart';

class LoanLenderListView extends GetView<LoanLenderListController> {
  const LoanLenderListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Peminjaman (Lender)'),
        actions: [
          PopupMenuButton<String?>(
            onSelected: controller.setFilter,
            itemBuilder:
                (_) => [
                  const PopupMenuItem(value: null, child: Text('Semua')),
                  const PopupMenuItem(value: 'PENDING', child: Text('Pending')),
                  const PopupMenuItem(
                    value: 'ACCEPTED',
                    child: Text('Accepted'),
                  ),
                  const PopupMenuItem(value: 'PAID', child: Text('Paid')),
                  const PopupMenuItem(
                    value: 'REJECTED',
                    child: Text('Rejected'),
                  ),
                ],
            icon: const Icon(Icons.filter_alt),
          ),
        ],
      ),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return const Center(child: Text('Belum ada peminjaman'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final loan = controller.items[i];
            final product = loan['product'] ?? {};
            final borrower = loan['customer'] ?? {};
            final status = '${loan['status']}';
            final host = ApiClient.url.replaceAll('/api', '');
            final imageUrl =
                product['image_url'] != null
                    ? '$host/images/${product['image_url']}'
                    : null;
            final subtitle =
                'Borrower: ${borrower['name'] ?? ''} • Rp ${loan['amount']}';

            Color badgeColor;
            switch (status) {
              case 'PENDING':
                badgeColor = Colors.orange;
                break;
              case 'ACCEPTED':
                badgeColor = Colors.blue;
                break;
              case 'PAID':
                badgeColor = Colors.green;
                break;
              case 'REJECTED':
                badgeColor = Colors.red;
                break;
              default:
                badgeColor = Colors.grey;
            }

            return ListTile(
              onTap: () => controller.onTapLoan(loan),
              leading:
                  imageUrl != null
                      ? Image.network(
                        imageUrl,
                        width: 56,
                        height: 56,
                        fit: BoxFit.cover,
                      )
                      : Container(
                        width: 56,
                        height: 56,
                        color: Colors.grey[200],
                      ),
              title: Text('${product['name'] ?? '(produk)'}'),
              subtitle: Text(subtitle),
              trailing: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: TextStyle(color: badgeColor, fontSize: 12),
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
