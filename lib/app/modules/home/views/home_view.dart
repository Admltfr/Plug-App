import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/routes/app_pages.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Produk'), centerTitle: true),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.searchController,
                    decoration: const InputDecoration(
                      hintText: 'Cari produk...',
                      prefixIcon: Icon(Icons.search),
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => controller.onSearch(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton(
                  onPressed: controller.onSearch,
                  child: const Text('Cari'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: Obx(() {
                if (controller.isLoading.value && controller.products.isEmpty) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (controller.products.isEmpty) {
                  return const Center(child: Text('Tidak ada produk'));
                }
                return GridView.builder(
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 8,
                    mainAxisSpacing: 8,
                    childAspectRatio: 0.8,
                  ),
                  itemCount: controller.products.length,
                  itemBuilder: (_, i) {
                    final p = controller.products[i];
                    return InkWell(
                      onTap: () => Get.toNamed('${Routes.PRODUCT}/${p.id}'),
                      child: Card(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              child:
                                  p.imageUrl != null
                                      ? Image.network(
                                        '${ApiClient.url.replaceAll('/api', '')}/images/${p.imageUrl}',
                                        fit: BoxFit.cover,
                                        width: double.infinity,
                                      )
                                      : Container(color: Colors.grey[200]),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(8),
                              child: Text(
                                p.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                              ),
                              child: Text(
                                'Rp ${p.price}',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              }),
            ),
            const SizedBox(height: 8),
            Obx(
              () => Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Hal ${controller.page}/${controller.totalPages}'),
                  const SizedBox(width: 16),
                  OutlinedButton(
                    onPressed:
                        controller.page.value > 1 ? controller.prevPage : null,
                    child: const Text('Prev'),
                  ),
                  const SizedBox(width: 8),
                  OutlinedButton(
                    onPressed:
                        controller.page.value < controller.totalPages.value
                            ? controller.nextPage
                            : null,
                    child: const Text('Next'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
