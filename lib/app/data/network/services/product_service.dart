import 'package:dio/dio.dart';
import 'package:plug/app/data/network/api_client.dart';
import 'package:plug/app/utils/try_catcher.dart';
import 'package:plug/app/utils/logger.dart';
import 'package:plug/app/data/models/product.dart';

class Paginated<T> {
  final List<T> items;
  final int page;
  final int limit;
  final int total;
  final int totalPages;
  Paginated(this.items, this.page, this.limit, this.total, this.totalPages);
}

class ProductService {
  final ApiClient api;
  ProductService(this.api);

  Future<Paginated<Product>> fetchProducts({
    int page = 1,
    int limit = 10,
    String search = '',
    String? sellerId,
  }) async {
    final response = await tryOrNullAsync<Response>(() async {
      return await api.public.get(
        '/product',
        queryParameters: {
          'page': page,
          'limit': limit,
          if (search.isNotEmpty) 'search': search,
          if (sellerId?.isNotEmpty == true) 'seller_id': sellerId,
        },
      );
    }, tag: 'ProductsFetch');

    if (response == null) throw Exception('Gagal memuat produk.');

    final List<Product> items =
        (response.data['data'] as List)
            .map((e) => Product.fromJson(e))
            .toList();
    final meta = response.data['pagination'];

    logSuccess('Produk dimuat: ${items.length}', tag: 'ProductsFetch');

    return Paginated<Product>(
      items,
      meta['page'],
      meta['limit'],
      meta['total'],
      meta['totalPages'],
    );
  }

  Future<Product> fetchProduct(String id) async {
    final response = await tryOrNullAsync<Response>(
      () async => await api.public.get('/product/$id'),
      tag: 'ProductDetail',
    );
    if (response == null) throw Exception('Gagal memuat detail produk.');

    final payload = response.data;
    final data = payload['data'];

    return Product.fromJson(Map<String, dynamic>.from(data.first as Map));
  }
}
