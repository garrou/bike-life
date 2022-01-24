import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class TipService {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> getAll() async {
    return await client.get(Uri.parse('$endpoint/tips'));
  }

  Future<Response> getByType(String type) async {
    return await client.get(Uri.parse('$endpoint/tips/types/$type'));
  }
}
