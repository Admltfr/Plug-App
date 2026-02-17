import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';

class QrView extends StatefulWidget {
  const QrView({super.key});
  @override
  State<QrView> createState() => _QrViewState();
}

class _QrViewState extends State<QrView> {
  String token = '';
  bool loading = true;
  late final MeetingService service;

  @override
  void initState() {
    super.initState();
    service = MeetingService(Get.find<ApiClient>());
    final loanId = Get.parameters['loanId'] ?? '';
    _gen(loanId);
  }

  Future<void> _gen(String loanId) async {
    try {
      final res = await service.generateQr(loanId);
      setState(() {
        token = '${res['token']}';
        loading = false;
      });
    } catch (e) {
      setState(() => loading = false);
      Get.snackbar('Gagal', e.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('QR Pertemuan')),
      body: SafeArea(
        child: Center(
          child:
              loading
                  ? const CircularProgressIndicator()
                  : QrImageView(
                    data: token,
                    version: QrVersions.auto,
                    size: 240,
                  ),
        ),
      ),
    );
  }
}
