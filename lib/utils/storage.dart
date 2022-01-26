import 'package:shared_preferences/shared_preferences.dart';

class Storage {
  static Future<String?> getToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('jwt');
  }

  static Future<String> getMemberId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('id') ?? "";
  }

  static Future<String> getBikeId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getString('bike') ?? "";
  }

  static disconnect() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('jwt');
    prefs.remove('id');
  }

  static setString(String key, String value) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }
}
