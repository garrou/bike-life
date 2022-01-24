import 'dart:convert';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class TipService {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<List<Tip>> getAll() async {
    Response response = await client.get(Uri.parse('$endpoint/tips'));
    return createTipsFromList(jsonDecode(response.body));
  }
}
