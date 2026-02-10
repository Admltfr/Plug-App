import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/role_utils.dart';
import '../controllers/wallet_home_controller.dart';

class WalletHomeView extends GetView<WalletHomeController> {
  const WalletHomeView({super.key});
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Wallet')),
      body: Obx(() {
        if (controller.isLoading.value)
          return const Center(child: CircularProgressIndicator());
        return Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              Text('Balance: ${controller.balance.value}'),
              const SizedBox(height: 12),
              if (RoleUtils.isBorrower())
                ElevatedButton(
                  onPressed: () => Get.toNamed(Routes.TOPUP),
                  child: const Text('Top Up'),
                ),
              ElevatedButton(
                onPressed: controller.refreshBalance,
                child: const Text('Refresh Saldo'),
              ),
            ],
          ),
        );
      }),
    );
  }
}
