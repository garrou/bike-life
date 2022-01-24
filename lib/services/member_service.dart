import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

class MemberService {
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

  Future<Response> update(int id, String email, String password) async {
    return await http.patch(Uri.parse('$endpoint/members/$id'),
        body: jsonEncode(
            <String, dynamic>{'id': id, 'email': email, 'password': password}));
  }
}
