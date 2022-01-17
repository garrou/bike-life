import 'dart:convert';

import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:http/http.dart' as http;

class MemberRepository {
  Future<List<dynamic>> login(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('$endpoint/login'),
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    dynamic jsonResponse = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Storage.write('jwt', jsonResponse['accessToken']);
      Storage.write('id', jsonResponse['member']['id'].toString());
    }
    return [response.statusCode == httpCodeOk, jsonResponse];
  }

  Future<List<dynamic>> signup(String email, String password) async {
    http.Response response = await http.post(
      Uri.parse('$endpoint/members'),
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return [response.statusCode == httpCodeCreated, jsonDecode(response.body)];
  }

  Future<List<dynamic>> updateMember(
      int id, String email, String password) async {
    http.Response response = await http.patch(
        Uri.parse('$endpoint/members/$id'),
        body: jsonEncode(
            <String, dynamic>{'id': id, 'email': email, 'password': password}));
    return [response.statusCode == httpCodeOk, jsonEncode(response.body)];
  }

  Future<Member?> getMemberById(int memberId) async {
    http.Response response =
        await http.get(Uri.parse('$endpoint/members/$memberId'));
    return response.statusCode == httpCodeOk ? jsonDecode(response.body) : null;
  }
}
