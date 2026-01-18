class Seller {
  final String id;
  final String name;
  final String email;

  Seller({required this.id, required this.name, required this.email});

  factory Seller.fromJson(Map<String, dynamic> j) =>
      Seller(id: j['id'], name: j['name'], email: j['email']);
}
