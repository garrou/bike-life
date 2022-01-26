import 'dart:async';

import 'package:bike_life/utils/storage.dart';

class GuardHelper {
  static checkIfLogged(StreamController streamController) async {
    String token = await Storage.getToken();
    token != "" ? streamController.add(true) : streamController.add(false);
  }
}
