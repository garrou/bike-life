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
    Response response = await http.post(
      Uri.parse('$endpoint/login'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> signup(String email, String password) async {
    Response response = await http.post(
      Uri.parse('$endpoint/members'),
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8'
      },
      body: jsonEncode(<String, String>{'email': email, 'password': password}),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> update(String id, String email, String password) async {
    Response response = await client.patch(Uri.parse('$endpoint/members/$id'),
        body: jsonEncode(
            <String, dynamic>{'id': id, 'email': email, 'password': password}));
    return HttpResponse(response);
  }

  Future<HttpResponse> getEmail(String id) async {
    Response response = await client.get(Uri.parse('$endpoint/members/$id'));
    return HttpResponse(response);
  }
}
