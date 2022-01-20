import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentTypesRepository {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<dynamic> getTypes() async {
    Response response =
        await client.get(Uri.parse('$endpoint/component-types'));
    return jsonDecode(response.body);
  }
}
