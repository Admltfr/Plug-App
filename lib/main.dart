import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'app/routes/app_pages.dart';
import 'app/data/network/api_client.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'app/utils/token_storage.dart';

Future main() async {
  await dotenv.load(fileName: ".env");
  final apiClient = ApiClient();

  final saved = await TokenStorage.readToken();
  if (saved != null && saved.isNotEmpty) {
    apiClient.authInterceptor.authToken = saved;
  }

  Get.put<ApiClient>(apiClient, permanent: true);

  runApp(
    GetMaterialApp(
      title: "Application",
      initialRoute: AppPages.INITIAL,
      getPages: AppPages.routes,
    ),
  );
}
