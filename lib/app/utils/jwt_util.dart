import 'package:jwt_decoder/jwt_decoder.dart';

String? getUserIdFromToken(String? token) {
  if (token == null || token.isEmpty) return null;
  final payload = JwtDecoder.decode(token);
  return payload['id'] as String?;
}

String? getRoleFromToken(String? token) {
  if (token == null || token.isEmpty) return null;
  final payload = JwtDecoder.decode(token);
  return payload['role'] as String?;
}

bool isTokenExpired(String? token) {
  if (token == null || token.isEmpty) return true;
  return JwtDecoder.isExpired(token);
}
