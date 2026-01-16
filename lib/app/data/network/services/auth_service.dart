import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/constants/app_enums.dart';

class AuthService {
  final ApiClient apiClient;
  AuthService(this.apiClient);

  Future<String> login({
    required String email,
    required String password,
  }) async {
    final Response response = await apiClient.public.post(
      '/auth/login',
      data: {'email': email, 'password': password},
    );

    final data = response.data;
    final token =
        data?['accessToken'] ??
        data?['token'] ??
        data?['access_token'] ??
        data?['data']?['accessToken'] ??
        data?['data']?['token'] ??
        data?['data']?['access_token'];

    if (token is! String || token.isEmpty) {
      throw Exception('Token tidak ditemukan pada response.');
    }

    apiClient.authInterceptor.authToken = token;
    return token;
  }

  Future<void> register({
    required String name,
    required String email,
    required String password,
    required String passwordConfirmation,
    required UserRole role,
  }) async {
    await apiClient.public.post(
      '/auth/register',
      data: {
        'name': name,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
        'role': role.apiValue, // SELLER | CUSTOMER
      },
    );
  }
}
