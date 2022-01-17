import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Storage {
  static const FlutterSecureStorage _flutterSecureStorage =
      FlutterSecureStorage();

  static Future<String?> getToken() async {
    return await _flutterSecureStorage.read(key: 'jwt');
  }

  static Future<int> getMemberId() async {
    String? id = await _flutterSecureStorage.read(key: 'id');

    if (id == null) {
      return -1;
    }
    return int.parse(id);
  }

  static void disconnect() async {
    await _flutterSecureStorage.delete(key: 'jwt');
    await _flutterSecureStorage.delete(key: 'id');
  }

  static write(String key, String value) async {
    _flutterSecureStorage.write(key: key, value: value);
  }
}
