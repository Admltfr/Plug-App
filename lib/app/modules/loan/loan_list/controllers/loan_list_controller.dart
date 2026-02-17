import 'package:get/get.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/loan_service.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/routes/app_pages.dart';

class LoanListController extends GetxController {
  final api = Get.find<ApiClient>();
  late final LoanService loanService = LoanService(api);
  late final ChatService chatService = ChatService(api);

  final isLoading = false.obs;
  final items = <Loan>[].obs;

  @override
  void onInit() {
    super.onInit();
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final list = await loanService.borrowerLoans();
      items.assignAll(list);
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> refresh() async {
    await load();
  }

  Future<void> onTapLoan(Loan loan) async {
    final status = loan.status.name;
    if (status == 'PENDING') {
      await Get.toNamed(Routes.PRODUCT, parameters: {'id': loan.productId});
      await refresh();
      return;
    }
    if (status == 'ACCEPTED' ||
        status == 'PAID' ||
        status == 'MEETING' ||
        status == 'WAITING_FOR_RETURN') {
      await Get.toNamed(Routes.LOAN_DETAIL, arguments: {'loan': loan.toJson()});
      await refresh();
      return;
    }
  }
}
