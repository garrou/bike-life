import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class Helper {
  static Future<String?> getMemberId() async {
    return await const FlutterSecureStorage().read(key: 'id');
  }

  static void disconnect() async {
    const storage = FlutterSecureStorage();
    await storage.delete(key: 'jwt');
    await storage.delete(key: 'id');
  }
}
