import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/jwt_util.dart';
import 'package:plug/app/constants/app_enums.dart';

class RoleUtils {
  static AppRole currentRole() {
    final api = Get.find<ApiClient>();
    final token = api.authInterceptor.authToken;
    final roleStr = getRoleFromToken(token) ?? '';
    if (roleStr.toUpperCase() == 'CUSTOMER') return AppRole.CUSTOMER;
    if (roleStr.toUpperCase() == 'SELLER') return AppRole.SELLER;
    throw Exception('Unknown user role: $roleStr');
  }

  static bool isBorrower() => currentRole() == AppRole.CUSTOMER;
  static bool isLender() => currentRole() == AppRole.SELLER;
}
