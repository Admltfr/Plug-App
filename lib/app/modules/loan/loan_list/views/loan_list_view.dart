import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import '../controllers/loan_list_controller.dart';

class LoanListView extends GetView<LoanListController> {
  const LoanListView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Peminjaman Saya')),
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
            final status = '${loan['status']}';
            final host = ApiClient.url.replaceAll('/api', '');
            final imageUrl =
                product['image_url'] != null
                    ? '$host/images/${product['image_url']}'
                    : null;
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
              subtitle: Text('Status: $status • Rp ${loan['amount']}'),
              trailing: const Icon(Icons.chevron_right),
            );
          },
        );
      }),
    );
  }
}
