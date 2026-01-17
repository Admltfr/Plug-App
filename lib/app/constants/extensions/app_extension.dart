import 'package:flutter/material.dart';

extension ContextExtension on BuildContext {
  double get width => MediaQuery.of(this).size.width;
  double get height => MediaQuery.of(this).size.height;
}

extension ExceptionExtension on Exception {
  String get message => toString().replaceFirst('Exception: ', '');

  String toLogString({StackTrace? stackTrace, String? tag}) {
    final border = '════════════════════════════════════════';
    final header = tag != null ? '[$tag]' : 'Exception';
    final trace = stackTrace == null ? '' : '\nStackTrace:\n$stackTrace';
    return '$border\n$header: $message$trace\n$border';
  }

  void log({StackTrace? stackTrace, String? tag}) {
    debugPrint(toLogString(stackTrace: stackTrace, tag: tag));
  }
}
