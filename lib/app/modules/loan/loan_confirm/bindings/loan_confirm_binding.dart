import 'package:get/get.dart';

import '../controllers/loan_confirm_controller.dart';

class LoanConfirmBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanConfirmController>(
      () => LoanConfirmController(),
    );
  }
}
