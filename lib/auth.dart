import 'dart:convert';

import 'package:bike_life/constants.dart';
import 'package:http/http.dart' as http;

Future<http.Response> login(String email, String password) {
  return http.post(
    Uri.parse("$androidEndpoint/login"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8"
    },
    body: jsonEncode(<String, String>{"email": email, "password": password}),
  );
}

Future<http.Response> signup(String email, String password) {
  return http.post(
    Uri.parse("$androidEndpoint/signup"),
    headers: <String, String>{
      "Content-Type": "application/json; charset=UTF-8"
    },
    body: jsonEncode(<String, String>{"email": email, "password": password}),
  );
}
