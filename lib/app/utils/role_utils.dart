import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/jwt_util.dart';
import 'package:plug/app/constants/app_enums.dart';

class RoleUtils {
  static AppRole currentRole() {
    final api = Get.find<ApiClient>();
    final token = api.authInterceptor.authToken;
    final roleStr = getRoleFromToken(token) ?? '';
    if (roleStr.toUpperCase() == 'BORROWER') return AppRole.BORROWER;
    if (roleStr.toUpperCase() == 'LENDER') return AppRole.LENDER;
    throw Exception('Unknown user role: $roleStr');
  }

  static bool isBorrower() => currentRole() == AppRole.BORROWER;
  static bool isLender() => currentRole() == AppRole.LENDER;
}
