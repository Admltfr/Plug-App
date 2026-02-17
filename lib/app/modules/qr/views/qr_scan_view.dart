import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:qr_code_scanner_plus/qr_code_scanner_plus.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';

class QrScanView extends StatefulWidget {
  const QrScanView({super.key});
  @override
  State<QrScanView> createState() => _QrScanViewState();
}

class _QrScanViewState extends State<QrScanView> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  late final MeetingService service;
  String loanId = '';
  bool done = false;

  @override
  void initState() {
    super.initState();
    service = MeetingService(Get.find<ApiClient>());
    loanId = Get.parameters['loanId'] ?? '';
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  void _onQRViewCreated(QRViewController c) {
    controller = c;
    controller!.scannedDataStream.listen((scanData) async {
      if (done) return;
      final token = scanData.code ?? '';
      if (token.isEmpty) return;
      done = true;
      try {
        await service.scan(loanId, token: token);
        Get.back(result: true);
        Get.snackbar('Sukses', 'Transfer diselesaikan');
      } catch (e) {
        done = false;
        Get.snackbar('Gagal', e.toString());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Scan QR')),
      body: SafeArea(
        child: QRView(key: qrKey, onQRViewCreated: _onQRViewCreated),
      ),
    );
  }
}
