import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class MemberService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> updatePassword(String password) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/member/password'),
        body: jsonEncode(<String, String>{'password': password}));
    return HttpResponse(response);
  }

  Future<HttpResponse> updateEmail(String email) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/member/email'),
        body: jsonEncode(<String, String>{'email': email}));
    return HttpResponse(response);
  }

  Future<HttpResponse> getEmail() async {
    final Response response =
        await client.get(Uri.parse('$endpoint/member/email'));
    return HttpResponse(response);
  }
}
