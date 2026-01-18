class Store {
  final String id;
  final String name;
  final String address;
  final double lat;
  final double lng;
  Store({
    required this.id,
    required this.name,
    required this.address,
    required this.lat,
    required this.lng,
  });
  factory Store.fromJson(Map<String, dynamic> j) => Store(
    id: j['id'],
    name: j['name'],
    address: j['address'],
    lat: (j['lat'] as num).toDouble(),
    lng: (j['lng'] as num).toDouble(),
  );
}
