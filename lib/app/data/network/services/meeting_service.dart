import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/try_catcher.dart';
import 'package:plug/app/utils/logger.dart';

class MeetingService {
  final ApiClient api;
  MeetingService(this.api);

  Future<Map<String, dynamic>> getMeeting(String loanId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get('/meeting/$loanId');
    }, tag: 'MeetingGet');
    if (res == null) throw Exception('Gagal memuat meeting.');
    final data = Map<String, dynamic>.from(res.data['data'] ?? {});
    logSuccess('Meeting fetched', tag: 'MeetingGet');
    return data;
  }

  Future<Map<String, dynamic>> proposeLocation(
    String loanId, {
    required double lat,
    required double lon,
    required String address,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/meeting/$loanId/location',
        data: {'lat': lat, 'lon': lon, 'address': address},
      );
    }, tag: 'MeetingPropose');
    if (res == null) throw Exception('Gagal mengirim lokasi.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess('Meeting proposed', tag: 'MeetingPropose');
    return data;
  }

  Future<Map<String, dynamic>> decide(
    String loanId, {
    required String decision,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.patch(
        '/meeting/$loanId/decision',
        data: {'decision': decision},
      );
    }, tag: 'MeetingDecision');
    if (res == null) throw Exception('Gagal mengirim keputusan.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess('Meeting decision: $decision', tag: 'MeetingDecision');
    return data;
  }

  Future<Map<String, dynamic>> generateQr(String loanId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/meeting/$loanId/qr');
    }, tag: 'MeetingQRGen');
    if (res == null) throw Exception('Gagal membuat QR.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess('QR generated', tag: 'MeetingQRGen');
    return data;
  }

  Future<void> scan(String loanId, String token) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/meeting/$loanId/scan',
        data: {'token': token},
      );
    }, tag: 'MeetingScan');
    if (res == null) throw Exception('Gagal memproses scan.');
    logSuccess('Scan finalized', tag: 'MeetingScan');
  }
}
