import 'dart:convert';
import 'package:http/http.dart';

class HttpResponse {
  late final dynamic _body;
  late final bool _success;

  HttpResponse(Response response) {
    _success = [200, 201].contains(response.statusCode);
    _body = jsonDecode(response.body);
  }

  String message() => _body['confirm'];

  String token() => _body['accessToken'];

  String email() => _body['email'];

  bool success() => _success;

  dynamic body() => _body;
}
