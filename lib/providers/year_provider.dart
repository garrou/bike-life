import 'package:flutter/material.dart';

class Year extends ChangeNotifier {
  int _value;

  Year(this._value);

  int get value {
    return _value;
  }

  set value(int value) {
    _value = value;
    notifyListeners();
  }
}
