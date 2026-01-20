import 'dart:math';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/product_service.dart';
import 'package:plug/app/data/network/services/store_service.dart';
import 'package:plug/app/data/network/services/warehouse_service.dart';
import 'package:plug/app/data/network/services/subscription_service.dart';
import 'package:plug/app/data/models/product.dart';
import 'package:plug/app/data/models/store.dart';
import 'package:plug/app/data/models/warehouse.dart';
import 'package:plug/app/utils/jwt_util.dart';
import 'package:plug/app/utils/auth_guard.dart';
import 'package:plug/app/routes/app_pages.dart';

double haversineKm(double lat1, double lon1, double lat2, double lon2) {
  const R = 6371.0;
  final dLat = (lat2 - lat1) * pi / 180.0;
  final dLon = (lat2 - lon1) * pi / 180.0;
  final a =
      sin(dLat / 2) * sin(dLat / 2) +
      cos(lat1 * pi / 180.0) *
          cos(lat2 * pi / 180.0) *
          sin(dLon / 2) *
          sin(dLon / 2);
  final c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return R * c;
}

class SubscriptionCreateController extends GetxController {
  final api = Get.find<ApiClient>();
  late final ProductService productService = ProductService(api);
  late final StoreService storeService = StoreService(api);
  late final WarehouseService warehouseService = WarehouseService(api);
  late final SubscriptionService subscriptionService = SubscriptionService(api);

  final isLoading = false.obs;
  final product = Rxn<Product>();
  final warehouse = Rxn<Warehouse>();
  final stores = <Store>[].obs;

  final selectedStoreId = ''.obs;
  final quantity = 1.obs;
  final frequencyDays = 1.obs;
  final distanceKm = Rxn<double>();
  final pricePerCycle = 0.0.obs;

  String? get _token => api.authInterceptor.authToken;
  String? get _customerId => getUserIdFromToken(_token);

  @override
  void onInit() {
    super.onInit();
    requireAuthOrRedirect(api);

    final productId = Get.parameters['productId'] ?? '';
    load(productId);
  }

  Future<void> load(String productId) async {
    isLoading.value = true;
    try {
      final p = await productService.fetchProduct(productId);
      product.value = p;

      warehouse.value = await warehouseService.fetchById(p.warehouseId);

      if (_customerId == null)
        throw Exception('Token tidak valid, user id tidak ditemukan');

      final list = await storeService.fetchByCustomer(_customerId!);
      stores.assignAll(list);
      selectedStoreId.value = list.isNotEmpty ? list.first.id : '';
      computePriceAndDistance();
    } finally {
      isLoading.value = false;
    }
  }

  Store? _selectedStore() =>
      stores.firstWhereOrNull((st) => st.id == selectedStoreId.value);

  void computePriceAndDistance() {
    final p = product.value;
    final w = warehouse.value;
    final s = _selectedStore();
    if (p != null) pricePerCycle.value = (p.price.toDouble()) * quantity.value;
    distanceKm.value =
        (w != null && s != null)
            ? haversineKm(s.lat, s.lng, w.lat, w.lng)
            : null;
  }

  void onSelectStore(String id) {
    selectedStoreId.value = id;
    computePriceAndDistance();
  }

  void onChangeQty(int q) {
    quantity.value = q;
    computePriceAndDistance();
  }

  void onChangeFreq(int f) {
    frequencyDays.value = f;
  }

  Future<void> submit() async {
    final p = product.value!;
    final w = warehouse.value!;
    final s = _selectedStore();
    if (_customerId == null) throw Exception('Token tidak valid');
    if (s == null) {
      Get.snackbar(
        'Gagal',
        'Pilih warung terlebih dahulu',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }
    await subscriptionService.create(
      productId: p.id,
      customerId: _customerId!,
      sellerId: p.seller.id,
      warehouseId: w.id,
      storeId: s.id,
      quantity: quantity.value,
      frequencyDays: frequencyDays.value,
    );
    Get.offAllNamed(Routes.SUBSCRIPTIONS);
  }
}
