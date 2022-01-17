import 'package:bike_life/utils/storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpAccountInterceptor implements InterceptorContract {
  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? accessToken = await Storage.getToken();

    data.headers['Content-Type'] = 'application/json; charset=UTF-8';
    data.headers['authorization'] = 'Bearer $accessToken';
    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async =>
      data;
}
