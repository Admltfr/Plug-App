import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/jwt_util.dart';
import 'package:plug/app/routes/app_pages.dart';

void requireAuthOrRedirect(ApiClient api) {
  final token = api.authInterceptor.authToken;
  if (token == null || isTokenExpired(token)) {
    Get.offAllNamed(Routes.LOGIN);
    throw Exception('Sesi tidak valid. Silakan login kembali.');
  }
}
