import 'dart:io';
import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/try_catcher.dart';
import 'package:plug/app/utils/logger.dart';

class ChatService {
  final ApiClient api;
  ChatService(this.api);

  Future<Map<String, dynamic>> ensureRoom(
    String otherId, {
    required String productId,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/chat/room',
        data: {'otherId': otherId, 'productId': productId},
      );
    }, tag: 'ChatEnsureRoom');
    if (res == null) throw Exception('Gagal memastikan room.');
    final data = Map<String, dynamic>.from(res.data['data']);
    logSuccess(
      'Room siap: ${data['id'] ?? data['roomId']}',
      tag: 'ChatEnsureRoom',
    );
    return data;
  }

  Future<List<Map<String, dynamic>>> getMessages(
    String roomId, {
    String? cursor,
    int take = 20,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/chat/messages/$roomId',
        queryParameters: {if (cursor != null) 'cursor': cursor, 'take': take},
      );
    }, tag: 'ChatGetMessages');
    if (res == null) throw Exception('Gagal memuat pesan.');
    final list = List<Map<String, dynamic>>.from(res.data['data']['messages']);
    logSuccess('Pesan dimuat: ${list.length}', tag: 'ChatGetMessages');
    return list;
  }

  Future<String> uploadImage(File file) async {
    final form = FormData.fromMap({
      'image': await MultipartFile.fromFile(
        file.path,
        filename: file.uri.pathSegments.last,
      ),
    });
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.post('/chat/upload', data: form);
    }, tag: 'ChatUpload');
    if (res == null) throw Exception('Gagal upload gambar.');
    final url = res.data['data']['imageUrl'] as String;
    logSuccess('Upload OK: $url', tag: 'ChatUpload');
    return url;
  }
}
