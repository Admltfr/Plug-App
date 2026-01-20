import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/data/models/subscription.dart';
import 'package:plug/app/utils/try_catcher.dart';

class SubscriptionService {
  final ApiClient api;
  SubscriptionService(this.api);

  Future<void> create({
    required String productId,
    required String customerId,
    required String sellerId,
    required String warehouseId,
    required String storeId,
    required int quantity,
    required int frequencyDays,
  }) async {
    await tryOrNullAsync<Response>(() async {
      return await api.private.post(
        '/subscription',
        data: {
          'product_id': productId,
          'customer_id': customerId,
          'warehouse_id': warehouseId,
          'store_id': storeId,
          'quantity': quantity,
          'frequency_days': frequencyDays,
        },
      );
    }, tag: 'SubscriptionCreate');
  }

  Future<List<Subscription>> listByCustomer(
    String customerId, {
    int page = 1,
    int limit = 10,
  }) async {
    final res = await tryOrNullAsync<Response>(() async {
      return await api.private.get(
        '/subscription/customer',
        queryParameters: {
          'customer_id': customerId,
          'page': page,
          'limit': limit,
        },
      );
    }, tag: 'SubscriptionListCustomer');
    if (res == null) throw Exception('Gagal memuat subscriptions');
    return (res.data['data'] as List)
        .map((e) => Subscription.fromJson(e))
        .toList();
  }
}
