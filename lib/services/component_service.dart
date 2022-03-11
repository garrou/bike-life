import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> getBikeComponents(String bikeId) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/bikes/$bikeId/components'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getComponentsAlerts(String memberId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/members/$memberId/components/nb-alerts'));
    return HttpResponse(response);
  }

  Future<HttpResponse> changeComponent(String componentId, DateTime date,
      double km, double kmBeforeChange) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/components/$componentId'),
        body: jsonEncode(<String, dynamic>{
          'changedAt': date.toString(),
          'km': km,
          'kmBeforeChange': kmBeforeChange
        }));
    return HttpResponse(response);
  }

  Future<HttpResponse> getChangeHistoric(String componentId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/components/$componentId/change-historic'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getNbComponentsChangeStats(
      String memberId, int year) async {
    final Response response = await client.get(Uri.parse(
        '$endpoint/members/$memberId/components/nb-change-stats/years/$year'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getKmComponentsChangeStats(
      String memberId, int year) async {
    final Response response = await client.get(Uri.parse(
        '$endpoint/members/$memberId/components/km-change-stats/years/$year'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getTotalChanges(String memberId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/members/$memberId/components/nb-changes'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getAvgPercentsChanges(String memberId) async {
    final Response response = await client
        .get(Uri.parse('$endpoint/members/$memberId/components/percents'));
    return HttpResponse(response);
  }
}
