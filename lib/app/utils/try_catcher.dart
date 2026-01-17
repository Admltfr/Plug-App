import 'package:plug/app/constants/extensions/app_extension.dart';

typedef AsyncFunc<T> = Future<T> Function();
typedef SyncFunc<T> = T Function();

T? tryOrNull<T>(SyncFunc<T> block, {String? tag}) {
  try {
    return block();
  } on Exception catch (e, s) {
    e.log(stackTrace: s, tag: tag);
    return null;
  } catch (e, s) {
    Exception(e.toString()).log(stackTrace: s, tag: tag);
    return null;
  }
}

Future<T?> tryOrNullAsync<T>(AsyncFunc<T> block, {String? tag}) async {
  try {
    return await block();
  } on Exception catch (e, s) {
    e.log(stackTrace: s, tag: tag);
    return null;
  } catch (e, s) {
    Exception(e.toString()).log(stackTrace: s, tag: tag);
    return null;
  }
}

T tryOrDefault<T>(SyncFunc<T> block, {required T defaultValue, String? tag}) {
  final v = tryOrNull<T>(block, tag: tag);
  return v ?? defaultValue;
}

Future<T> tryOrDefaultAsync<T>(
  AsyncFunc<T> block, {
  required T defaultValue,
  String? tag,
}) async {
  final v = await tryOrNullAsync<T>(block, tag: tag);
  return v ?? defaultValue;
}
