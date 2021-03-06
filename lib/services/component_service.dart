import 'dart:convert';

import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/component_change.dart';
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
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getComponentsAlerts(String bikeId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components/nb-alerts'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> changeComponent(
      String componentId, ComponentChange componentChange) async {
    final Response response = await client.patch(
      Uri.parse('$endpoint/components/$componentId'),
      body: jsonEncode(componentChange),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> updateComponent(Component component) async {
    final Response response = await client.put(
      Uri.parse('$endpoint/components/${component.id}'),
      body: jsonEncode(component),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getChangeHistoric(String componentId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/$componentId/change-historic'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getNbComponentsChangeStats(int year) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/nb-change-stats/years/$year'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getKmComponentsChangeStats(int year) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/km-change-stats/years/$year'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getTotalChanges() async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/nb-changes'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getAvgPercentsChanges() async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/percents'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getNbChangesByBike(String bikeId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components/nb-change-stats'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getAvgPercentChangesByBike(String bikeId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components/percents'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getNumOfCompoChangedByBike(String bikeId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components/nb-change-stats'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getSumPriceComponentsMember() async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/price'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getSumPriceComponentsBike(String bikeId) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/bikes/$bikeId/components/price'),
    );
    return HttpResponse(response);
  }

  Future<HttpResponse> getComponentsBySearch(String search) async {
    final Response response = await client.get(
      Uri.parse('$endpoint/components/$search'),
    );
    return HttpResponse(response);
  }
}
