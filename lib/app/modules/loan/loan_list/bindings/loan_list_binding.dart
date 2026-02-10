import 'package:get/get.dart';

import '../controllers/loan_list_controller.dart';

class LoanListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanListController>(
      () => LoanListController(),
    );
  }
}
