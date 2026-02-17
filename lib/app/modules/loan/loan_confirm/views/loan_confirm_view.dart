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
      body: SafeArea(
        child: Obx(() {
          if (controller.isLoading.value) {
            return const Center(child: CircularProgressIndicator());
          }
          final items = controller.items;
          if (items.isEmpty) {
            return const Center(child: Text('Tidak ada permintaan'));
          }
          return ListView.separated(
            padding: const EdgeInsets.all(16),
            itemCount: items.length,
            separatorBuilder: (_, __) => const SizedBox(height: 12),
            itemBuilder: (_, i) {
              final loan = items[i];
              final product = loan.product;
              final borrower = loan.borrower;
              final id = loan.id;
              final amount = loan.amount;
              final host = ApiClient.url.replaceAll('/api', '');
              final imageUrl =
                  product?.imageUrl != null
                      ? '$host/images/${product!.imageUrl}'
                      : null;
              product?.imageUrl != null
                  ? '$host/images/${product?.imageUrl}'
                  : null;

              return Card(
                elevation: 2,
                child: Padding(
                  padding: const EdgeInsets.all(12),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: SizedBox(
                              width: 72,
                              height: 72,
                              child:
                                  imageUrl != null
                                      ? Image.network(
                                        imageUrl,
                                        fit: BoxFit.cover,
                                      )
                                      : Container(color: Colors.grey[200]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  '${product?.name ?? '(produk)'}',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Text('Borrower: ${borrower?.name ?? ''}'),
                                const SizedBox(height: 4),
                                Text('Jumlah: Rp $amount'),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      Row(
                        children: [
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: () => controller.accept(id),
                              icon: const Icon(Icons.check),
                              label: const Text('Terima'),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: () => controller.reject(id),
                              icon: const Icon(Icons.close),
                              label: const Text('Tolak'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
