import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> getBikeComponents(String bikeId) async {
    return await client.get(Uri.parse('$endpoint/bikes/$bikeId/components'));
  }

  Future<Response> getComponentsAlerts(String memberId) async {
    return await client
        .get(Uri.parse('$endpoint/members/$memberId/components/alerts'));
  }
}
