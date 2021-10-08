import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http_interceptor/http_interceptor.dart';

class HttpAccountInterceptor implements InterceptorContract {
  final storage = const FlutterSecureStorage();

  @override
  Future<RequestData> interceptRequest({required RequestData data}) async {
    String? accessToken = await storage.read(key: 'jwt');

    data.headers['Content-Type'] = 'application/json';

    if (accessToken != null) {
      data.headers['authorization'] = 'Bearer $accessToken';
    }

    return data;
  }

  @override
  Future<ResponseData> interceptResponse({required ResponseData data}) async {
    return data;
  }
}
