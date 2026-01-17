import 'package:get/get.dart';
import 'package:plug/app/data/models/product.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/product_service.dart';
import 'package:plug/app/utils/logger.dart';

class ProductController extends GetxController {
  final id = ''.obs;
  final isLoading = false.obs;
  final product = Rxn<Product>();
  late final ProductService service = ProductService(ApiClient());
  @override
  void onInit() {
    super.onInit();
    id.value = Get.parameters['id'] ?? '';
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      product.value = await service.fetchProduct(id.value);
      logInfo('Detail loaded: ${product.value?.name}', tag: 'ProductDetail');
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }
}
