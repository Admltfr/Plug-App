class Borrower {
  final String id;
  final String name;
  final String? email;

  Borrower({required this.id, required this.name, this.email});

  factory Borrower.fromJson(Map<String, dynamic> j) =>
      Borrower(id: j['id'], name: j['name'] ?? '', email: j['email']);
}
