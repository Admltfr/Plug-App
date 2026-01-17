import 'package:flutter/foundation.dart';

void logSuccess(String message, {String? tag}) {
  const border = '════════════════════════════════════════';
  final header = tag != null ? '[SUCCESS][$tag]' : '[SUCCESS]';
  debugPrint('$border\n$header: $message\n$border');
}

void logInfo(String message, {String? tag}) {
  const border = '════════════════════════════════════════';
  final header = tag != null ? '[INFO][$tag]' : '[INFO]';
  debugPrint('$border\n$header: $message\n$border');
}
