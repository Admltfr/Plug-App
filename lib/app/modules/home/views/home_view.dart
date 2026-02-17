import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/role_utils.dart';
import '../controllers/home_controller.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final isBorrower = RoleUtils.isBorrower();
    final isLender = RoleUtils.isLender();

    return Scaffold(
      appBar: AppBar(
        title: Text(isBorrower ? 'Produk' : 'Menu Lender'),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.account_balance_wallet),
            tooltip: 'Wallet Saya',
            onPressed: () => Get.toNamed(Routes.WALLET_HOME),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(12),
        child:
            isBorrower
                ? Column(
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(Routes.TOPUP),
                            child: const Text('Top Up'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: ElevatedButton(
                            onPressed: () => Get.toNamed(Routes.LOAN_LIST),
                            child: const Text('Peminjaman Saya'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
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
                        if (controller.isLoading.value &&
                            controller.products.isEmpty) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        }
                        if (controller.products.isEmpty) {
                          return const Center(child: Text('Tidak ada produk'));
                        }
                        return GridView.builder(
                          gridDelegate:
                              const SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 8,
                                mainAxisSpacing: 8,
                                childAspectRatio: 0.8,
                              ),
                          itemCount: controller.products.length,
                          itemBuilder: (_, i) {
                            final p = controller.products[i];
                            final host = ApiClient.url.replaceAll('/api', '');
                            final imageUrl =
                                p.imageUrl != null
                                    ? '$host/images/${p.imageUrl}'
                                    : null;
                            return InkWell(
                              onTap:
                                  () => Get.toNamed(
                                    Routes.PRODUCT,
                                    parameters: {'id': p.id},
                                  ),
                              child: Card(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Expanded(
                                      child:
                                          imageUrl != null
                                              ? Image.network(
                                                imageUrl,
                                                fit: BoxFit.cover,
                                                width: double.infinity,
                                              )
                                              : Container(
                                                color: Colors.grey[200],
                                              ),
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
                                        style: const TextStyle(
                                          color: Colors.grey,
                                        ),
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
                          Text(
                            'Hal ${controller.page}/${controller.totalPages}',
                          ),
                          const SizedBox(width: 16),
                          OutlinedButton(
                            onPressed:
                                controller.page.value > 1
                                    ? controller.prevPage
                                    : null,
                            child: const Text('Prev'),
                          ),
                          const SizedBox(width: 8),
                          OutlinedButton(
                            onPressed:
                                controller.page.value <
                                        controller.totalPages.value
                                    ? controller.nextPage
                                    : null,
                            child: const Text('Next'),
                          ),
                        ],
                      ),
                    ),
                  ],
                )
                : ListView(
                  padding: const EdgeInsets.all(16),
                  children: [
                    ListTile(
                      leading: const Icon(Icons.assignment_turned_in),
                      title: const Text('Konfirmasi Peminjaman'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed(Routes.LOAN_CONFIRM),
                    ),
                    ListTile(
                      leading: const Icon(Icons.account_balance_wallet),
                      title: const Text('Wallet Saya'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed(Routes.WALLET_HOME),
                    ),
                    ListTile(
                      leading: const Icon(Icons.list_alt),
                      title: const Text('Daftar Peminjaman Saya'),
                      trailing: const Icon(Icons.chevron_right),
                      onTap: () => Get.toNamed(Routes.LOAN_LENDER_LIST),
                    ),
                  ],
                ),
      ),
    );
  }
}
