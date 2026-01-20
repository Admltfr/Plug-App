import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/subscription_create_controller.dart';

class SubscriptionCreateView extends GetView<SubscriptionCreateController> {
  const SubscriptionCreateView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Langganan Produk')),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        final p = controller.product.value;
        final w = controller.warehouse.value;
        if (p == null || w == null)
          return const Center(child: Text('Data tidak lengkap'));
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                p.name,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              Text('Warehouse: ${w.name}'),
              const SizedBox(height: 8),
              DropdownButton<String>(
                value:
                    controller.selectedStoreId.value.isEmpty
                        ? null
                        : controller.selectedStoreId.value,
                hint: const Text('Pilih Warung Anda'),
                items:
                    controller.stores
                        .map(
                          (s) => DropdownMenuItem(
                            value: s.id,
                            child: Text('${s.name} - ${s.address}'),
                          ),
                        )
                        .toList(),
                onChanged:
                    (v) => v != null ? controller.onSelectStore(v) : null,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  const Text('Qty:'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: controller.quantity.value,
                    items:
                        List.generate(20, (i) => i + 1)
                            .map(
                              (q) =>
                                  DropdownMenuItem(value: q, child: Text('$q')),
                            )
                            .toList(),
                    onChanged:
                        (v) => v != null ? controller.onChangeQty(v) : null,
                  ),
                  const SizedBox(width: 20),
                  const Text('Frekuensi (hari):'),
                  const SizedBox(width: 8),
                  DropdownButton<int>(
                    value: controller.frequencyDays.value,
                    items:
                        const [1, 2, 3, 5, 7, 10, 14, 21, 30]
                            .map(
                              (f) =>
                                  DropdownMenuItem(value: f, child: Text('$f')),
                            )
                            .toList(),
                    onChanged:
                        (v) => v != null ? controller.onChangeFreq(v) : null,
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Obx(
                () => Text(
                  'Harga per siklus: Rp ${controller.pricePerCycle.value.toStringAsFixed(0)}',
                ),
              ),
              const SizedBox(height: 8),
              Obx(
                () => Text(
                  'Jarak: ${controller.distanceKm.value?.toStringAsFixed(2) ?? '-'} km',
                ),
              ),
              const Spacer(),
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: controller.submit,
                  child: const Text('Ajukan Langganan'),
                ),
              ),
            ],
          ),
        );
      }),
    );
  }
}
