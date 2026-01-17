import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/services/auth_service.dart';
import 'package:plug/app/constants/app_enums.dart';
import 'package:plug/app/utils/logger.dart';

class RegisterController extends GetxController {
  final AuthService authService;
  RegisterController({required this.authService});

  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final selectedRole = UserRole.customer.obs;
  final isLoading = false.obs;

  Future<void> register() async {
    if (isLoading.value) return;
    final pwd = passwordController.text;
    final confirm = confirmPasswordController.text;

    if (pwd != confirm) {
      Get.snackbar(
        'Validasi gagal',
        'Password dan konfirmasi tidak sama.',
        snackPosition: SnackPosition.BOTTOM,
      );
      return;
    }

    isLoading.value = true;
    try {
      await authService.register(
        name: nameController.text.trim(),
        email: emailController.text.trim(),
        password: pwd,
        passwordConfirmation: confirm,
        role: selectedRole.value,
      );
      logInfo('Registrasi sukses, kembali ke login', tag: 'RegisterController');
      Get.back();
      Get.snackbar(
        'Berhasil',
        'Registrasi berhasil. Silakan login.',
        snackPosition: SnackPosition.BOTTOM,
      );
    } catch (e) {
      Get.snackbar(
        'Registrasi gagal',
        e.toString(),
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    nameController.dispose();
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }
}
