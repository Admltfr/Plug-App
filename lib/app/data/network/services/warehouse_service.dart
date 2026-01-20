import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/models/warehouse.dart';
import 'package:plug/app/utils/try_catcher.dart';

class WarehouseService {
  final ApiClient api;
  WarehouseService(this.api);

  Future<Warehouse> fetchById(String id) async {
    final res = await tryOrNullAsync<Response>(
      () async => await api.private.get('/warehouse/$id'),
      tag: 'WarehouseDetail',
    );
    if (res == null) throw Exception('Gagal memuat warehouse');
    return Warehouse.fromJson(res.data['data']);
  }

  Future<List<Warehouse>> fetchBySeller(
    String sellerId, {
    int page = 1,
    int limit = 10,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/warehouse',
        queryParameters: {'seller_id': sellerId, 'page': page, 'limit': limit},
      );
    }, tag: 'WarehouseListSeller');
    if (res == null) throw Exception('Gagal memuat warehouses');
    return (res.data['data'] as List)
        .map((e) => Warehouse.fromJson(e))
        .toList();
  }
}
