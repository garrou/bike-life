import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class MemberService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> login(String email, String password) async {
    return await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
  }

  Future<Response> signup(String email, String password) async {
    return await http.post(
      Uri.parse('$endpoint/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
  }

  Future<Response> update(String id, String email, String password) async {
    return await client.patch(Uri.parse('$endpoint/members/$id'),
        body: jsonEncode(
            <String, dynamic>{'id': id, 'email': email, 'password': password}));
  }

  Future<Response> getEmail(String id) async {
    return await client.get(Uri.parse('$endpoint/members/$id'));
  }
}
