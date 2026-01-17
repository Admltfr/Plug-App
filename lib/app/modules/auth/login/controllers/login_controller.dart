import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/services/auth_service.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/logger.dart';

class LoginController extends GetxController {
  final AuthService authService;
  LoginController({required this.authService});

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final isLoading = false.obs;

  Future<void> login() async {
    if (isLoading.value) return;
    isLoading.value = true;
    try {
      await authService.login(
        email: emailController.text.trim(),
        password: passwordController.text,
      );
      logInfo('Navigasi ke HOME setelah login', tag: 'LoginController');
      Get.offAllNamed(Routes.HOME);
    } catch (e) {
      Get.snackbar(
        'Login gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  void goToRegister() {
    Get.toNamed(Routes.REGISTER);
  }

  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    super.onClose();
  }
}
