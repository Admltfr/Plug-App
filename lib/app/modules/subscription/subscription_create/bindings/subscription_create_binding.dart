import 'package:get/get.dart';

import '../controllers/subscription_create_controller.dart';

class SubscriptionCreateBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SubscriptionCreateController>(
      () => SubscriptionCreateController(),
    );
  }
}
