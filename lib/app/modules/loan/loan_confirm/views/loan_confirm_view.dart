import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/loan_confirm_controller.dart';
import 'package:plug/app/data/network/api_client.dart';

class LoanConfirmView extends GetView<LoanConfirmController> {
  const LoanConfirmView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Konfirmasi Peminjaman')),
      body: Obx(() {
        if (controller.isLoading.value && controller.items.isEmpty) {
          return const Center(child: CircularProgressIndicator());
        }
        if (controller.items.isEmpty) {
          return const Center(child: Text('Tidak ada permintaan peminjaman'));
        }
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final loan = controller.items[i];
            final product = loan['product'] ?? {};
            final borrower = loan['customer'] ?? {};
            final amount = loan['amount'];
            final id = '${loan['id']}';

            final host = ApiClient.url.replaceAll('/api', '');
            final imageUrl =
                product['image_url'] != null
                    ? '$host/images/${product['image_url']}'
                    : null;

            return Card(
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      width: 72,
                      height: 72,
                      child:
                          imageUrl != null
                              ? Image.network(imageUrl, fit: BoxFit.cover)
                              : Container(color: Colors.grey[200]),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '${product['name'] ?? '(produk)'}',
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          const SizedBox(height: 4),
                          Text('Borrower: ${borrower['name'] ?? ''}'),
                          Text('Jumlah: Rp $amount'),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              TextButton(
                                onPressed: () => controller.reject(id),
                                child: const Text('Tolak'),
                              ),
                              const SizedBox(width: 8),
                              ElevatedButton(
                                onPressed: () => controller.accept(id),
                                child: const Text('Terima'),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      }),
    );
  }
}
