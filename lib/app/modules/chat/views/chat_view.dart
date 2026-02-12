import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/role_utils.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import '../controllers/chat_controller.dart';

class ChatView extends GetView<ChatController> {
  const ChatView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chat')),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Obx(() {
                  final m = controller.meeting.value;
                  final hasMeeting = m != null;
                  if (!hasMeeting) return const SizedBox.shrink();

                  final status = '${m!['status'] ?? ''}';
                  final lat = double.tryParse('${m['lat']}') ?? 0.0;
                  final lon = double.tryParse('${m['lon']}') ?? 0.0;
                  final addr = '${m['address'] ?? ''}';
                  final point = LatLng(lat, lon);

                  final isBorrower = RoleUtils.isBorrower();
                  final showActions = isBorrower && status == 'PENDING';

                  return Container(
                    margin: const EdgeInsets.all(8),
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(color: Colors.blue.shade200),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 140,
                          child: FlutterMap(
                            options: MapOptions(
                              initialCenter: point,
                              initialZoom: 15,
                            ),
                            children: [
                              TileLayer(
                                urlTemplate:
                                    'https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png',
                                subdomains: const ['a', 'b', 'c'],
                                userAgentPackageName: 'plug.app',
                              ),
                              MarkerLayer(
                                markers: [
                                  Marker(
                                    point: point,
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
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(addr, style: const TextStyle(fontSize: 13)),
                        const SizedBox(height: 8),
                        if (showActions)
                          Row(
                            children: [
                              Expanded(
                                child: OutlinedButton(
                                  onPressed: controller.acceptMeeting,
                                  child: const Text('Accept'),
                                ),
                              ),
                              const SizedBox(width: 8),
                              Expanded(
                                child: ElevatedButton(
                                  onPressed: controller.rejectMeeting,
                                  child: const Text('Reject'),
                                ),
                              ),
                            ],
                          )
                        else
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              status == 'PENDING'
                                  ? 'Menunggu keputusan borrower'
                                  : 'Status lokasi: $status',
                              style: TextStyle(
                                fontSize: 12,
                                color:
                                    status == 'PENDING'
                                        ? Colors.orange
                                        : Colors.green,
                              ),
                            ),
                          ),
                      ],
                    ),
                  );
                }),
                Expanded(
                  child: Obx(() {
                    final items = controller.messages;
                    return ListView.builder(
                      reverse: true,
                      itemCount: items.length,
                      itemBuilder: (_, i) {
                        final m = items[i];
                        final sender = '${m['sender'] ?? ''}';
                        final content = '${m['content'] ?? ''}';
                        final rawImage = m['image_url'];
                        final isImage =
                            rawImage != null && (rawImage as String).isNotEmpty;

                        Widget title;
                        if (isImage) {
                          final host = ApiClient.url.replaceAll('/api', '');
                          final path = rawImage;
                          final imageUrl =
                              path.startsWith('/images')
                                  ? '$host$path'
                                  : '$host/images/$path';

                          title = GestureDetector(
                            onTap: () {
                              Get.dialog(
                                Dialog(
                                  backgroundColor: Colors.black,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.zero,
                                  ),
                                  insetPadding: EdgeInsets.zero,
                                  child: SizedBox.expand(
                                    child: Stack(
                                      children: [
                                        InteractiveViewer(
                                          minScale: 0.5,
                                          maxScale: 4.0,
                                          child: Center(
                                            child: Image.network(
                                              imageUrl,
                                              fit: BoxFit.contain,
                                              errorBuilder:
                                                  (_, __, ___) => const Padding(
                                                    padding: EdgeInsets.all(16),
                                                    child: Text(
                                                      'Gambar gagal dimuat',
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                      ),
                                                    ),
                                                  ),
                                            ),
                                          ),
                                        ),
                                        Positioned(
                                          top: 12,
                                          right: 12,
                                          child: IconButton(
                                            icon: const Icon(
                                              Icons.close,
                                              color: Colors.white,
                                            ),
                                            onPressed: () => Get.back(),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                barrierColor: Colors.black87,
                                barrierDismissible: true,
                              );
                            },
                            child: Image.network(
                              imageUrl,
                              height: 160,
                              fit: BoxFit.cover,
                              errorBuilder:
                                  (_, __, ___) =>
                                      const Text('Gambar gagal dimuat'),
                            ),
                          );
                        } else {
                          title = Text(
                            content.isEmpty ? '(pesan kosong)' : content,
                            style: const TextStyle(fontSize: 16),
                          );
                        }

                        return ListTile(
                          title: title,
                          subtitle: Text(sender),
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                        );
                      },
                    );
                  }),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: controller.textCtrl,
                    decoration: const InputDecoration(
                      hintText: 'Tulis pesan...',
                      border: OutlineInputBorder(),
                      isDense: true,
                    ),
                    minLines: 1,
                    maxLines: 3,
                  ),
                ),
                const SizedBox(width: 8),
                if (RoleUtils.isLender())
                  IconButton(
                    onPressed: () async {
                      final loanId = Get.parameters['loanId'] ?? '';
                      if (loanId.isEmpty) {
                        Get.snackbar('Info', 'Context loanId tidak ditemukan');
                        return;
                      }
                      final result = await Get.toNamed(
                        Routes.QR_SCAN,
                        parameters: {'loanId': loanId},
                      );
                      if (result == true) {
                        await controller.reloadMeeting();
                        Get.snackbar(
                          'Sukses',
                          'Scan berhasil, menunggu pengembalian',
                        );
                      }
                    },
                    icon: const Icon(Icons.location_on),
                    tooltip: 'Kirim lokasi',
                  ),
                if (RoleUtils.isLender())
                  IconButton(
                    onPressed: () {
                      final loanId = Get.parameters['loanId'] ?? '';
                      if (loanId.isEmpty) {
                        Get.snackbar('Info', 'Context loanId tidak ditemukan');
                        return;
                      }
                      Get.toNamed(
                        Routes.QR_SCAN,
                        parameters: {'loanId': loanId},
                      );
                    },
                    icon: const Icon(Icons.qr_code_scanner),
                    tooltip: 'Scan QR',
                  ),
                IconButton(
                  onPressed: controller.sendImage,
                  icon: const Icon(Icons.image),
                  tooltip: 'Kirim gambar',
                ),
                IconButton(
                  onPressed: controller.sendText,
                  icon: const Icon(Icons.send),
                  tooltip: 'Kirim pesan',
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
