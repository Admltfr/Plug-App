import 'package:dio/dio.dart';
import 'package:plug/app/data/network/interceptors/auth_interceptor.dart';

class ApiClient {
  static final String baseUrl = "https://api.example.com";
  final Dio public;
  final Dio private;
  final AuthInterceptor authInterceptor;

  ApiClient()
    : public = Dio(BaseOptions(baseUrl: baseUrl)),
      private = Dio(BaseOptions(baseUrl: baseUrl)),
      authInterceptor = AuthInterceptor() {
    private.interceptors.add(authInterceptor);
  }
}
