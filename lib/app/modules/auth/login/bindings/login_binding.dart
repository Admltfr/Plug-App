import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/auth_service.dart';

import '../controllers/login_controller.dart';

class LoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AuthService>(() => AuthService(Get.find<ApiClient>()));
    Get.lazyPut<LoginController>(() => LoginController(authService: Get.find<AuthService>()));
  }
}
