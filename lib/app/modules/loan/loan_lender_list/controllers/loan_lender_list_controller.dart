import 'package:get/get.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/loan_service.dart';
import 'package:plug/app/routes/app_pages.dart';

class LoanLenderListController extends GetxController {
  final api = Get.find<ApiClient>();
  late final LoanService loanService = LoanService(api);

  final isLoading = false.obs;
  final items = <Loan>[].obs;
  final filterStatus = RxnString();

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final list = await loanService.lenderLoans(status: filterStatus.value);
      items.assignAll(list);
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void setFilter(String? status) {
    filterStatus.value = status;
    load();
  }

  void onTapLoan(Loan loan) {
    Get.toNamed(Routes.LOAN_DETAIL, arguments: {'loan': loan.toJson()});
  }
}
