import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:plug/app/constants/app_enums.dart';
import 'package:plug/app/data/models/meeting.dart';
import 'package:plug/app/routes/app_pages.dart';
import 'package:plug/app/utils/role_utils.dart';
import 'package:socket_io_client/socket_io_client.dart' as IO;
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/network/services/chat_service.dart';
import 'package:plug/app/data/network/services/meeting_service.dart';

class ChatController extends GetxController {
  final api = Get.find<ApiClient>();
  late final ChatService chat = ChatService(api);
  late final MeetingService meetingService = MeetingService(api);

  final messages = <Map<String, dynamic>>[].obs;
  final meeting = Rxn<Meeting>();
  final textCtrl = TextEditingController();
  IO.Socket? socket;
  late final String roomId;
  late final String otherId;
  late final String loanId;

  @override
  void onInit() {
    super.onInit();
    roomId = Get.parameters['roomId'] ?? '';
    otherId = Get.parameters['otherId'] ?? '';
    loanId = Get.parameters['loanId'] ?? '';
    _connectSocket();
    _loadInitial();
    _loadMeeting();
  }

  Future<void> _loadInitial() async {
    final list = await chat.getMessages(roomId);
    messages.assignAll(list);
  }

  Future<void> _loadMeeting() async {
    if (loanId.isEmpty) return;
    try {
      final m = await meetingService.getMeeting(loanId);
      meeting.value = m;
    } catch (_) {}
  }

  Future<void> reloadMeeting() async {
    await _loadMeeting();
  }

  void setMeetingLocal(Map<String, dynamic> result) {
    meeting.value = Meeting(
      loanId: loanId,
      lat: (result['lat'] as num).toDouble(),
      lon: (result['lon'] as num).toDouble(),
      address: result['address'] ?? '',
      status: MeetingStatus.PENDING,
    );
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
    socket!.on('meeting:updated', (_) => _loadMeeting());
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

  Future<void> sendLocation() async {
    if (!RoleUtils.isLender()) return;
    if (loanId.isEmpty) {
      Get.snackbar('Info', 'Context loanId tidak ditemukan');
      return;
    }
    final result = await Get.toNamed(
      Routes.LOCATION,
      parameters: {'loanId': loanId},
    );
    if (result is Map && result.isNotEmpty) {
      setMeetingLocal(Map<String, dynamic>.from(result));
    } else {
      await reloadMeeting();
    }
  }

  Future<void> acceptMeeting() async {
    if (loanId.isEmpty) {
      Get.snackbar('Info', 'loanId tidak ditemukan');
      return;
    }
    try {
      final updated = await meetingService.decide(loanId, decision: 'ACCEPT');
      meeting.value = updated;
      Get.snackbar('Sukses', 'Lokasi disetujui');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  Future<void> rejectMeeting() async {
    if (loanId.isEmpty) {
      Get.snackbar('Info', 'loanId tidak ditemukan');
      return;
    }
    try {
      final updated = await meetingService.decide(loanId, decision: 'REJECT');
      meeting.value = updated;
      Get.snackbar('Sukses', 'Lokasi ditolak');
    } catch (e) {
      Get.snackbar('Gagal', e.toString());
    }
  }

  @override
  void onClose() {
    textCtrl.dispose();
    socket?.dispose();
    super.onClose();
  }
}
