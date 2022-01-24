import 'dart:convert';

import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentTypesService {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<List<ComponentType>> getTypes() async {
    Response response =
        await client.get(Uri.parse('$endpoint/component-types'));
    return createComponentTypesFromList(jsonDecode(response.body));
  }
}
