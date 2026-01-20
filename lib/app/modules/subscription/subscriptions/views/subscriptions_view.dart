import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/routes/app_pages.dart';
import '../controllers/subscriptions_controller.dart';

class SubscriptionsView extends GetView<SubscriptionsController> {
  const SubscriptionsView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Langganan Saya'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (Get.previousRoute.isNotEmpty) {
              Get.back();
            } else {
              Get.offAllNamed(Routes.HOME);
            }
          },
        ),
      ),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        if (controller.items.isEmpty)
          return const Center(child: Text('Belum ada langganan'));
        return ListView.separated(
          padding: const EdgeInsets.all(12),
          itemCount: controller.items.length,
          separatorBuilder: (_, __) => const Divider(),
          itemBuilder: (_, i) {
            final s = controller.items[i];
            return ListTile(
              title: Text('${s.productName} • ${s.status}'),
              subtitle: Text(
                'Qty: ${s.quantity}, setiap ${s.frequencyDays} hari\n'
                'Warehouse: ${s.warehouseName}, Warung: ${s.storeName}\n'
                'Jarak: ${s.distanceKm?.toStringAsFixed(2) ?? '-'} km',
              ),
              trailing: Text('Rp ${s.pricePerCycle.toStringAsFixed(0)}'),
            );
          },
        );
      }),
    );
  }
}
