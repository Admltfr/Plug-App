import 'package:get/get.dart';
import 'package:plug/app/data/network/services/auth_service.dart';

import '../controllers/register_controller.dart';

class RegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterController>(
      () => RegisterController(authService: Get.find<AuthService>()),
    );
  }
}
