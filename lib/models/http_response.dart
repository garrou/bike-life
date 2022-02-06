import 'dart:convert';
import 'package:bike_life/styles/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class HttpResponse {
  late dynamic _body;
  late Color _color;
  late bool _success;

  HttpResponse(Response response) {
    _success = [200, 201].contains(response.statusCode);
    _color = _success ? primaryColor : red;
    _body = jsonDecode(response.body);
  }

  String message() => _body['confirm'];

  String token() => _body['accessToken'];

  String memberId() => _body['member']['id'];

  String email() => _body['email'];

  bool success() => _success;

  dynamic body() => _body;

  Color color() => _color;
}
