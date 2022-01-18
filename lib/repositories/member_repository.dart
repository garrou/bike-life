import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:http/http.dart' as http;

class MemberRepository {
  Future<List<dynamic>> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    dynamic jsonResponse = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Storage.setString('jwt', jsonResponse['accessToken']);
      Storage.setInt('id', jsonResponse['member']['id']);
    }
    return [response.statusCode == httpCodeOk, jsonResponse];
  }

  Future<List<dynamic>> signup(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('$endpoint/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return [response.statusCode == httpCodeCreated, jsonDecode(response.body)];
  }

  Future<List<dynamic>> update(int id, String email, String password) async {
    http.Response response = await http.patch(
        Uri.parse('$endpoint/members/$id'),
        body: jsonEncode(
            <String, dynamic>{'id': id, 'email': email, 'password': password}));
    return [response.statusCode == httpCodeOk, jsonEncode(response.body)];
  }

  Future<Member?> getMember(int memberId) async {
    http.Response response =
        await http.get(Uri.parse('$endpoint/members/$memberId'));
    return response.statusCode == httpCodeOk ? jsonDecode(response.body) : null;
  }
}
