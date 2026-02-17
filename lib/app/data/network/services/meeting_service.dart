import 'package:dio/dio.dart';
import 'package:plug/app/data/models/meeting.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/try_catcher.dart';

class MeetingService {
  final ApiClient api;
  MeetingService(this.api);

  Future<Meeting?> getMeeting(String loanId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get('/meeting/$loanId');
    }, tag: 'MeetingService.getMeeting');
    if (res == null) return null;
    final data = (res.data['data'] as Map<String, dynamic>?);
    if (data == null || data.isEmpty) return null;
    return Meeting.fromJson(data);
  }

  Future<Meeting> proposeLocation({
    required String loanId,
    required double lat,
    required double lon,
    required String address,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/meeting/$loanId/location',
        data: {'lat': lat, 'lon': lon, 'address': address},
      );
    }, tag: 'MeetingService.proposeLocation');
    if (res == null) throw Exception('Gagal kirim lokasi');
    return Meeting.fromJson(res.data['data']);
  }

  Future<Meeting> decide(String loanId, {required String decision}) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.patch(
        '/meeting/$loanId/decision',
        data: {'decision': decision},
      );
    }, tag: 'MeetingService.decide');
    if (res == null) throw Exception('Gagal memutuskan lokasi');
    return Meeting.fromJson(res.data['data']);
  }

  Future<Map<String, dynamic>> generateQr(String loanId) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/meeting/$loanId/qr');
    }, tag: 'MeetingService.generateQr');
    if (res == null) throw Exception('Gagal generate QR');
    return Map<String, dynamic>.from(res.data['data']);
  }

  Future<Map<String, dynamic>> scan(
    String loanId, {
    required String token,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/meeting/$loanId/scan',
        data: {'token': token},
      );
    }, tag: 'MeetingService.scan');
    if (res == null) throw Exception('Gagal scan QR');
    return Map<String, dynamic>.from(res.data['data']);
  }
}
