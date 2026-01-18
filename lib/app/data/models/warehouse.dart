class Warehouse {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;

  Warehouse({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });

  factory Warehouse.fromJson(Map<String, dynamic> j) => Warehouse(
    id: j['id'],
    name: j['name'],
    address: j['address'],
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
  );
}
