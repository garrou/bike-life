import 'dart:convert';

import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpResponse {
  late dynamic _body;
  late Color _color;
  late bool _success;
  late String _message;

  HttpResponse(Response response) {
    bool ok = [httpCodeCreated, httpCodeOk].contains(response.statusCode);
    _color = ok ? primaryColor : red;
    _success = ok;
    _body = jsonDecode(response.body);
    _message = _body[serverMessage];
  }

  String message() => _message;

  bool success() => _success;

  dynamic body() => _body;

  Color color() => _color;
}
