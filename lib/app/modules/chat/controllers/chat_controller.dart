import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/chat_service.dart';

class ChatController extends GetxController {
  final api = Get.find<ApiClient>();
  late final ChatService chat = ChatService(api);

  final messages = <Map<String, dynamic>>[].obs;
  final textCtrl = TextEditingController();
  IO.Socket? socket;
  late final String roomId;
  late final String otherId;

  @override
  void onInit() {
    super.onInit();
    roomId = Get.parameters['roomId'] ?? '';
    otherId = Get.parameters['otherId'] ?? '';
    _connectSocket();
    _loadInitial();
  }

  Future<void> _loadInitial() async {
    final list = await chat.getMessages(roomId);
    messages.assignAll(list);
  }

  Future<void> _connectSocket() async {
    final token = api.authInterceptor.authToken;
    final host = ApiClient.url.replaceAll('/api', '');
    socket = IO.io(
      host,
      IO.OptionBuilder()
          .setTransports(['websocket'])
          .enableForceNew()
          .setExtraHeaders({'Authorization': 'Bearer $token'})
          .setAuth({'token': token})
          .build(),
    );

    socket!.onConnect((_) => socket!.emit('chat:join', {'roomId': roomId}));
    socket!.on('chat:new', (data) {
      final msg = Map<String, dynamic>.from(data['message']);
      messages.insert(0, msg);
    });
  }

  Future<void> sendText() async {
    final text = textCtrl.text.trim();
    if (text.isEmpty) return;
    socket?.emit('chat:send', {'roomId': roomId, 'content': text});
    textCtrl.clear();
  }

  Future<void> sendImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);
    if (picked == null) return;
    final url = await chat.uploadImage(File(picked.path));
    socket?.emit('chat:send', {'roomId': roomId, 'imageUrl': url});
  }

  @override
  void onClose() {
    textCtrl.dispose();
    socket?.dispose();
    super.onClose();
  }
}
