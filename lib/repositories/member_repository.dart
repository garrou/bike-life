import 'dart:convert';

import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

class MemberRepository {
  Future<List<dynamic>> login(String email, String password) async {
    const storage = FlutterSecureStorage();
    Member? member;
    http.Response response = await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    dynamic jsonResponse = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      await storage.write(key: 'jwt', value: jsonResponse['accessToken']);
      member = Member.fromJson(jsonResponse['member']);
    }
    return [member, jsonResponse];
  }

  Future<List<dynamic>> signup(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('$endpoint/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    dynamic jsonResponse = jsonDecode(response.body);
    return [response.statusCode == httpCodeCreated, jsonResponse];
  }
}
