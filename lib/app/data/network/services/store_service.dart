import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/models/store.dart';
import 'package:plug/app/utils/try_catcher.dart';

class StoreService {
  final ApiClient api;
  StoreService(this.api);

  Future<List<Store>> fetchByCustomer(
    String customerId, {
    int page = 1,
    int limit = 10,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/store',
        queryParameters: {
          'customer_id': customerId,
          'page': page,
          'limit': limit,
        },
      );
    }, tag: 'StoreList');
    if (res == null) throw Exception('Gagal memuat stores');
    return (res.data['data'] as List).map((e) => Store.fromJson(e)).toList();
  }
}
