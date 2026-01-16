import 'package:dio/dio.dart';
import 'package:plug/app/data/network/interceptors/auth_interceptor.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class ApiClient {
  static final String? baseUrl = dotenv.env['BASEURL'];
  static final String url = '$baseUrl/api';
  final Dio public;
  final Dio private;
  final AuthInterceptor authInterceptor;

  ApiClient()
    : public = Dio(BaseOptions(baseUrl: url)),
      private = Dio(BaseOptions(baseUrl: url)),
      authInterceptor = AuthInterceptor() {
    private.interceptors.add(authInterceptor);
  }
}
