import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/location_controller.dart';

class LocationView extends GetView<LocationController> {
  const LocationView({super.key});

  @override
  Widget build(BuildContext context) {
    final init = const LatLng(-6.973, 107.630);
    return Scaffold(
      appBar: AppBar(title: const Text('Pilih Lokasi')),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              final marker = controller.picked.value;
              return FlutterMap(
                options: MapOptions(
                  initialCenter: init,
                  initialZoom: 15,
                  onTap: (tapPosition, latlng) => controller.onTap(latlng),
                ),
                children: [
                  TileLayer(
                    urlTemplate:
                        'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                    subdomains: const ['a', 'b', 'c'],
                    userAgentPackageName: 'plug.app',
                  ),
                  if (marker != null)
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: marker,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_on,
                            color: Colors.red,
                            size: 36,
                          ),
                        ),
                      ],
                    ),
                ],
              );
            }),
          ),
          Obx(
            () => Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  Text(
                    controller.address.isEmpty
                        ? 'Tap peta untuk memilih lokasi'
                        : controller.address.value,
                  ),
                  const SizedBox(height: 8),
                  ElevatedButton(
                    onPressed:
                        controller.picked.value == null ||
                                controller.isLoading.value
                            ? null
                            : controller.send,
                    child:
                        controller.isLoading.value
                            ? const CircularProgressIndicator()
                            : const Text('Kirim Lokasi'),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
