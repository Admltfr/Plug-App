import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:plug/app/utils/role_utils.dart';
import '../controllers/loan_detail_controller.dart';

class LoanDetailView extends GetView<LoanDetailController> {
  const LoanDetailView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Detail Peminjaman')),
      body: Obx(() {
        final loan = controller.loan.value;
        if (loan == null) {
          return const Center(child: Text('Data loan tidak ditemukan'));
        }
        final status = '${loan['status']}';
        final isBorrower = RoleUtils.isBorrower();
        final meetingStatus = '${controller.meeting.value?['status'] ?? ''}';

        return Column(
          children: [
            Expanded(
              child: ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  Text(
                    'Produk: ${loan['product']?['name'] ?? ''}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text('Jumlah: Rp ${loan['amount']}'),
                  const SizedBox(height: 8),
                  Text('Status: $status'),
                  const SizedBox(height: 16),
                  Obx(() {
                    final m = controller.meeting.value;
                    if (m == null) return const SizedBox.shrink();
                    final lat = double.tryParse('${m['lat']}') ?? 0.0;
                    final lon = double.tryParse('${m['lon']}') ?? 0.0;
                    final addr = '${m['address'] ?? ''}';
                    final point = LatLng(lat, lon);
                    return Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.grey.shade100,
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.grey.shade300),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Lokasi Pertemuan',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          const SizedBox(height: 8),
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
                          const SizedBox(height: 4),
                          Text(
                            'Status lokasi: ${m['status']}',
                            style: TextStyle(
                              fontSize: 12,
                              color:
                                  '${m['status']}' == 'PENDING'
                                      ? Colors.orange
                                      : Colors.green,
                            ),
                          ),
                        ],
                      ),
                    );
                  }),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                children: [
                  if (!isBorrower && controller.isWaitingForReturn) ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: controller.markReturned,
                        child: const Text('Barang sudah kembali'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  if (controller.isPaid && meetingStatus == 'ACCEPTED') ...[
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed:
                            isBorrower ? controller.showQr : controller.scanQr,
                        child: Text(isBorrower ? 'Tampilkan QR' : 'Scan QR'),
                      ),
                    ),
                    const SizedBox(height: 8),
                  ],
                  Row(
                    children: [
                      if (controller.isAccepted && isBorrower) ...[
                        Expanded(
                          child: ElevatedButton(
                            onPressed:
                                controller.isPaying.value
                                    ? null
                                    : controller.pay,
                            child:
                                controller.isPaying.value
                                    ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(),
                                    )
                                    : const Text('Bayar'),
                          ),
                        ),
                      ] else if (controller.isPaid ||
                          controller.isWaitingForReturn) ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: controller.chats,
                            child: const Text('Chat'),
                          ),
                        ),
                      ] else ...[
                        Expanded(
                          child: OutlinedButton(
                            onPressed: null,
                            child: Text(
                              controller.isPending
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
    );
  }
}
