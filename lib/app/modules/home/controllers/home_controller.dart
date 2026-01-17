import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/product_service.dart';
import 'package:plug/app/data/models/product.dart';
import 'package:plug/app/utils/logger.dart';

class HomeController extends GetxController {
  final api = ApiClient();
  late final ProductService service = ProductService(api);
  final searchController = TextEditingController();
  final isLoading = false.obs;
  final products = <Product>[].obs;
  final page = 1.obs;
  final limit = 10.obs;
  final totalPages = 1.obs;

  Future<void> loadProducts({int? toPage}) async {
    if (isLoading.value) return;
    isLoading.value = true;
    final currentPage = toPage ?? page.value;
    try {
      final result = await service.fetchProducts(
        page: currentPage,
        limit: limit.value,
        search: searchController.text.trim(),
      );
      products.assignAll(result.items);
      page.value = result.page;
      limit.value = result.limit;
      totalPages.value = result.totalPages;
      logInfo('Load page ${page.value}/${totalPages.value}', tag: 'Home');
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  void onSearch() => loadProducts(toPage: 1);
  void nextPage() {
    if (page.value < totalPages.value) loadProducts(toPage: page.value + 1);
  }

  void prevPage() {
    if (page.value > 1) loadProducts(toPage: page.value - 1);
  }

  @override
  void onInit() {
    super.onInit();
    loadProducts();
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}
