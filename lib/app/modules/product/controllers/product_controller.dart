import 'package:get/get.dart';
import 'package:plug/app/constants/app_enums.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/models/product.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/data/network/services/product_service.dart';
import 'package:plug/app/data/network/services/loan_service.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/logger.dart';

class ProductController extends GetxController {
  final id = ''.obs;
  final isLoading = false.obs;
  final product = Rxn<Product>();

  late final ProductService productService = ProductService(
    Get.find<ApiClient>(),
  );
  late final LoanService loanService = LoanService(Get.find<ApiClient>());

  final currentLoan = Rxn<Loan>();
  late final ChatService chatService = ChatService(Get.find<ApiClient>());

  @override
  void onInit() {
    super.onInit();
    id.value = Get.parameters['id'] ?? '';
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      product.value = await productService.fetchProduct(id.value);
      await _loadCurrentLoanState();
      logInfo('Detail loaded: ${product.value?.name}', tag: 'ProductDetail');
    } catch (e) {
      Get.snackbar('Gagal', e.toString(), snackPosition: SnackPosition.BOTTOM);
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _loadCurrentLoanState() async {
    final p = product.value;
    if (p == null) return;
    try {
      final loans = await loanService.borrowerLoans();
      final found = loans.firstWhereOrNull(
        (x) => x.productId == p.id && x.status != LoanStatus.COMPLETED,
      );
      currentLoan.value = found;
    } catch (_) {}
  }

  Future<void> requestLoan() async {
    final p = product.value;
    if (p == null) return;
    try {
      final loan = await loanService.createLoan(p.id);
      currentLoan.value = loan;
      Get.snackbar(
        'Berhasil',
        'Permintaan peminjaman dikirim (menunggu respons)',
      );
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> payAcceptedLoan() async {
    final loan = currentLoan.value;
    if (loan == null) return;
    Get.toNamed(
      Routes.LOAN_DETAIL,
      arguments: {'loan': currentLoan.value!.toJson()},
    );
  }

  Future<void> openLocationForPaid() async {
    final loan = currentLoan.value;
    if (loan == null) return;
    final loanId = loan.id;
    Get.toNamed(Routes.LOCATION, parameters: {'loanId': currentLoan.value!.id});
  }

  Future<void> openChatForPaid() async {
    final loan = currentLoan.value;
    if (loan == null) return;
    final lenderId = loan.lenderId;
    final productId = loan.productId;
    final room = await chatService.ensureRoom(lenderId, productId: productId);
    final roomId = room['id'] ?? room['roomId'];
    Get.toNamed(
      '/chat',
      parameters: {'roomId': '$roomId', 'otherId': lenderId, 'loanId': loan.id},
    );
  }
}
