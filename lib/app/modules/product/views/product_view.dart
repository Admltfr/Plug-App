import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import '../controllers/product_controller.dart';

class ProductView extends GetView<ProductController> {
  const ProductView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Produk')),
      body: Obx(() {
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }
        final p = controller.product.value;
        if (p == null) {
          return const Center(child: Text('Produk tidak ditemukan'));
        }
        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (p.imageUrl != null)
                Image.network(
                  '${ApiClient.url.replaceAll('/api', '')}/images/${p.imageUrl}',
                  height: 220,
                  fit: BoxFit.cover,
                ),
              const SizedBox(height: 12),
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Rp ${p.price}',
                style: const TextStyle(color: Colors.grey, fontSize: 16),
              ),
              const SizedBox(height: 12),
              Text(p.description ?? 'Tidak ada deskripsi'),
              const SizedBox(height: 12),
              Text(
                'Seller: ${p.seller.name} (${p.seller.email})',
                style: const TextStyle(fontSize: 12),
              ),
            ],
          ),
        );
      }),
    );
  }
}
