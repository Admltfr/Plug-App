class Seller {
  final String id;
  final String name;
  final String email;
  Seller({required this.id, required this.name, required this.email});
  factory Seller.fromJson(Map<String, dynamic> j) =>
      Seller(id: j['id'], name: j['name'], email: j['email']);
}

class Product {
  final String id;
  final String name;
  final String? description;
  final int price;
  final int stock;
  final String? imageUrl;
  final Seller seller;
  Product({
    required this.id,
    required this.name,
    this.description,
    required this.price,
    required this.stock,
    this.imageUrl,
    required this.seller,
  });
  factory Product.fromJson(Map<String, dynamic> j) => Product(
    id: j['id'],
    name: j['name'],
    description: j['description'],
    price: (j['price'] as num).toInt(),
    stock: (j['stock'] as num).toInt(),
    imageUrl: j['image_url'],
    seller: Seller.fromJson(j['seller']),
  );
}
