import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';
import 'package:plug/app/data/network/services/location_service.dart';

class LocationController extends GetxController {
  final api = Get.find<ApiClient>();
  late final MeetingService meeting = MeetingService(api);
  final loc = LocationService();

  final loanId = ''.obs;
  final picked = Rxn<LatLng>();
  final address = ''.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    loanId.value = Get.parameters['loanId'] ?? '';
  }

  Future<void> onTap(LatLng latlng) async {
    picked.value = latlng;
    isLoading.value = true;
    try {
      address.value = await loc.reverse(latlng.latitude, latlng.longitude);
    } catch (e) {
      address.value = 'Lat: ${latlng.latitude}, Lon: ${latlng.longitude}';
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> send() async {
    final p = picked.value;
    if (p == null) return;
    isLoading.value = true;
    try {
      await meeting.proposeLocation(
        loanId: loanId.value,
        lat: p.latitude,
        lon: p.longitude,
        address: address.value,
      );
      Get.back(
        result: {
          'lat': p.latitude,
          'lon': p.longitude,
          'address': address.value,
        },
      );
      Get.snackbar('Sukses', 'Lokasi dikirim');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    } finally {
      isLoading.value = false;
    }
  }
}
