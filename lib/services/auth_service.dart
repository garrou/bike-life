import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';

import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class AuthService {
  Future<HttpResponse> login(String email, String password) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> signup(
      String email, String password, String confirm) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{
        'email': email,
        'password': password,
        'confirm': confirm
      }),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> forgotPassword(String email) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/forgot'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email}),
    );
    return HttpResponse(response);
  }
}
