import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/repair.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class RepairService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> addRepair(Repair repair) async {
    final Response response = await client.post(
        Uri.parse('$endpoint/components/repairs'),
        body: jsonEncode(repair));
    return HttpResponse(response);
  }

  Future<HttpResponse> getRepairs(String componentId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/components/$componentId/repairs'));
    return HttpResponse(response);
  }
}
