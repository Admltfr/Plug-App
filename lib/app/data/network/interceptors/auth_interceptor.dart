import 'package:dio/dio.dart';

class AuthInterceptor extends Interceptor {
  String? authToken;

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    if (authToken != null && authToken!.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $authToken';
    }
    handler.next(options);
  }
}
