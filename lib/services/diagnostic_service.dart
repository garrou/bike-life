import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class DiagnosticService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> getDiagnosticsByBikeType(String type) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/diagnostics/$type'));
    return HttpResponse(response);
  }
}
