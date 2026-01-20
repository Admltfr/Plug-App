import 'seller.dart';

class Product {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String? imageUrl;
  final String warehouseId;
  final Seller seller;

  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.warehouseId,
    required this.seller,
  });

  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    price: (j['price'] as num).toInt(),
    stock: (j['stock'] as num).toInt(),
    imageUrl: j['image_url'],
    warehouseId: j['warehouse_id'],
    seller: Seller.fromJson(j['seller']),
  );
}
