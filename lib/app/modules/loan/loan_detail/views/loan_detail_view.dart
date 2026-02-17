import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';
import 'package:plug/app/utils/role_utils.dart';
import '../controllers/loan_detail_controller.dart';

class LoanDetailView extends GetView<LoanDetailController> {
  const LoanDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Peminjaman')),
      body: SafeArea(
        child: Obx(() {
          final loan = controller.loan.value;
          if (loan == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final status = controller.loan.value?.status.name ?? '';
          final isBorrower = RoleUtils.isBorrower();
          final meetingStatus = controller.meeting.value?.status.name ?? '';

          return Column(
            children: [
              Expanded(
                child: RefreshIndicator(
                  onRefresh: controller.refreshLoan,
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.all(16),
                    children: [
                      Card(
                        elevation: 2,
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Produk: ${controller.loan.value?.product?.name ?? '-'}',
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Jumlah: Rp ${controller.loan.value?.amount ?? 0}',
                              ),
                              const SizedBox(height: 8),
                              Text('Status: $status'),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      Obx(() {
                        final m = controller.meeting.value;
                        if (m == null) return const SizedBox.shrink();
                        final lat = double.tryParse('${m.lat}') ?? 0.0;
                        final lon = double.tryParse('${m.lon}') ?? 0.0;
                        final addr = '${m.address ?? ''}';
                        final point = LatLng(lat, lon);

                        return Card(
                          elevation: 2,
                          child: Padding(
                            padding: const EdgeInsets.all(12),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Lokasi Pertemuan',
                                  style: const TextStyle(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                SizedBox(
                                  height: 180,
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
                                Text(addr),
                                const SizedBox(height: 8),
                                Text(
                                  'Status lokasi: ${m.status.name}',
                                  style: TextStyle(
                                    fontSize: 12,
                                    color:
                                        m.status.name == 'PENDING'
                                            ? Colors.orange
                                            : Colors.green,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(12),
                child: Column(
                  children: [
                    if (!isBorrower && controller.isWaitingForReturn) ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed: controller.markReturned,
                          icon: const Icon(Icons.assignment_turned_in),
                          label: const Text('Barang sudah kembali'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    if (controller.isMeeting &&
                        meetingStatus == 'ACCEPTED') ...[
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton.icon(
                          onPressed:
                              isBorrower
                                  ? controller.showQr
                                  : controller.scanQr,
                          icon: Icon(
                            isBorrower ? Icons.qr_code : Icons.qr_code_scanner,
                          ),
                          label: Text(isBorrower ? 'Tampilkan QR' : 'Scan QR'),
                        ),
                      ),
                      const SizedBox(height: 8),
                    ],
                    Row(
                      children: [
                        if (controller.isAccepted && isBorrower) ...[
                          Expanded(
                            child: ElevatedButton.icon(
                              onPressed: controller.pay,
                              icon: const Icon(Icons.payments),
                              label: const Text('Bayar'),
                            ),
                          ),
                        ] else if (controller.isPaid ||
                            controller.isWaitingForReturn) ...[
                          Expanded(
                            child: OutlinedButton.icon(
                              onPressed: controller.chats,
                              icon: const Icon(Icons.chat_bubble_outline),
                              label: const Text('Chat'),
                            ),
                          ),
                        ] else ...[
                          Expanded(
                            child: OutlinedButton(
                              onPressed: null,
                              child: Text(
                                controller.isMeeting
                                    ? 'Menunggu hasil pertemuan'
                                    : controller.isPending
                                    ? 'Menunggu konfirmasi'
                                    : controller.isCompleted
                                    ? 'Transaksi selesai'
                                    : 'Menunggu pembayaran',
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
}
