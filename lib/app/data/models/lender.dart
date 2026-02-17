class Lender {
  final String id;
  final String name;
  final String email;

  Lender({required this.id, required this.name, required this.email});

  factory Lender.fromJson(Map<String, dynamic> j) =>
      Lender(id: j['id'], name: j['name'], email: j['email']);
}
