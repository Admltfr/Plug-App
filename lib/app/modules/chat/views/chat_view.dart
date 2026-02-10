import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:plug/app/data/network/api_client.dart';
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
                    title = Image.network(
                      imageUrl,
                      height: 160,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Text('Gambar gagal dimuat'),
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
