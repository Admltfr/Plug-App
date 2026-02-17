import 'package:get/get.dart';
import 'package:plug/app/data/models/loan.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/loan_service.dart';

class LoanConfirmController extends GetxController {
  late final LoanService service;
  final items = <Loan>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    service = LoanService(Get.find<ApiClient>());
    load();
  }

  Future<void> load() async {
    isLoading.value = true;
    try {
      final list = await service.lenderLoans(status: 'PENDING');
      items.assignAll(list);
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> accept(String id) async {
    try {
      await service.confirmLoan(id, 'ACCEPT');
      Get.snackbar('Sukses', 'Permintaan diterima');
      await load();
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> reject(String id) async {
    try {
      await service.confirmLoan(id, 'REJECT');
      Get.snackbar('Ditolak', 'Permintaan ditolak');
      await load();
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }
}
