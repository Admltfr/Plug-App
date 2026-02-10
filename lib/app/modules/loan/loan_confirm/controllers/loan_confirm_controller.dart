import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/loan_service.dart';

class LoanConfirmController extends GetxController {
  final api = Get.find<ApiClient>();
  late final LoanService service = LoanService(api);

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
      final data = await service.confirmLoan(id, 'ACCEPT');
      final roomId = '${data['roomId']}';
      final borrowerId = '${data['borrower_id']}';
      Get.snackbar('Sukses', 'Permintaan diterima');
      Get.toNamed(
        '/chat',
        parameters: {'roomId': roomId, 'otherId': borrowerId},
      );
      await load();
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> reject(String id) async {
    try {
      await service.confirmLoan(id, 'REJECT');
      Get.snackbar('Sukses', 'Permintaan ditolak');
      await load();
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }
}
