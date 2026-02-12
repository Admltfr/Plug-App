import 'dart:convert';
import 'package:http/http.dart' as http;

class LocationService {
  final _client = http.Client();

  Future<String> reverse(double lat, double lon) async {
    final uri = Uri.parse(
      'https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lon&zoom=18&addressdetails=1',
    );
    final res = await _client.get(uri, headers: {'User-Agent': 'plug-app/1.0'});
    if (res.statusCode != 200) throw Exception('Reverse geocoding gagal');
    final json = jsonDecode(res.body) as Map<String, dynamic>;
    return (json['display_name'] as String?) ?? 'Unknown location';
  }
}
