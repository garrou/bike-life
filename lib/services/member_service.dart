import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class MemberService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> login(String email, String password) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/members/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> signup(String email, String password) async {
    final Response response = await http.post(
      Uri.parse('$endpoint/members/signup'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> updatePassword(String memberId, String password) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/members/$memberId/password'),
        body: jsonEncode(<String, String>{'password': password}));
    return HttpResponse(response);
  }

  Future<HttpResponse> updateEmail(String memberId, String email) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/members/$memberId/email'),
        body: jsonEncode(<String, String>{'email': email}));
    return HttpResponse(response);
  }

  Future<HttpResponse> getEmail(String id) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/members/$id/email'));
    return HttpResponse(response);
  }
}
