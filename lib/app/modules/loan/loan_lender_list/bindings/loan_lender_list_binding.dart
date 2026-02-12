import 'package:get/get.dart';

import '../controllers/loan_lender_list_controller.dart';

class LoanLenderListBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<LoanLenderListController>(
      () => LoanLenderListController(),
    );
  }
}
