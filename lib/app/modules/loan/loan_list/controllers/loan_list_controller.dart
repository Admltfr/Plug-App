import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/loan_service.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/routes/app_pages.dart';

class LoanListController extends GetxController {
  final api = Get.find<ApiClient>();
  late final LoanService loanService = LoanService(api);
  late final ChatService chatService = ChatService(api);

  final isLoading = false.obs;
  final items = <Map<String, dynamic>>[].obs;

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

  void onTapLoan(Map<String, dynamic> loan) async {
    final status = '${loan['status']}';
    if (status == 'PENDING') {
      Get.toNamed(Routes.PRODUCT, parameters: {'id': '${loan['product_id']}'});
      return;
    }
    if (status == 'ACCEPTED') {
      Get.toNamed(Routes.LOAN_DETAIL, arguments: {'loan': loan});
      return;
    }
    if (status == 'PAID') {
      final lenderId = '${loan['lender_id']}';
      final productId = '${loan['product_id']}';
      final room = await chatService.ensureRoom(lenderId, productId: productId);
      final roomId = room['id'] ?? room['roomId'];
      Get.toNamed(
        '/chat',
        parameters: {'roomId': '$roomId', 'otherId': lenderId},
      );
      return;
    }
  }
}
