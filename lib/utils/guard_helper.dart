import 'dart:async';

import 'package:bike_life/utils/storage.dart';

class GuardHelper {
  static checkIfLogged(StreamController streamController) async {
    int memberId = await Storage.getMemberId();
    memberId != -1 ? streamController.add(true) : streamController.add(false);
  }
}
