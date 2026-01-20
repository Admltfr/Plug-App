import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/subscription_service.dart';
import 'package:plug/app/data/models/subscription.dart';
import 'package:plug/app/utils/jwt_util.dart';
import 'package:plug/app/utils/auth_guard.dart';

class SubscriptionsController extends GetxController {
  final api = Get.find<ApiClient>();
  late final SubscriptionService service = SubscriptionService(api);

  final items = <Subscription>[].obs;
  final isLoading = false.obs;

  String? get _token => api.authInterceptor.authToken;
  String? get _customerId => getUserIdFromToken(_token);

  @override
  void onInit() {
    super.onInit();
    requireAuthOrRedirect(api);
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      if (_customerId == null) throw Exception('Token tidak valid');
      final list = await service.listByCustomer(_customerId!);
      items.assignAll(list);
    } finally {
      isLoading.value = false;
    }
  }
}
