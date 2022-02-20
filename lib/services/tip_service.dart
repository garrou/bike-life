import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class TipService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> getAll() async {
    final Response response = await client.get(Uri.parse('$endpoint/tips'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getByTopic(String topic) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/topics/$topic/tips'));
    return HttpResponse(response);
  }
}
