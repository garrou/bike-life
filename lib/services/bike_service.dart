import 'dart:convert';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class BikeService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<HttpResponse> create(Bike bike) async {
    final Response response = await client
        .post(Uri.parse('$endpoint/member/bikes'), body: jsonEncode(bike));
    return HttpResponse(response);
  }

  Future<HttpResponse> getOne(String bikeId) async {
    final Response response =
        await client.get(Uri.parse('$endpoint/bikes/$bikeId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getByMember() async {
    final Response response =
        await client.get(Uri.parse('$endpoint/member/bikes'));
    return HttpResponse(response);
  }

  Future<HttpResponse> delete(String bikeId) async {
    final Response response =
        await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> update(Bike bike) async {
    final Response response = await client.put(
        Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
    return HttpResponse(response);
  }

  Future<HttpResponse> addKm(String bikeId, double km) async {
    final Response response = await client.patch(
        Uri.parse('$endpoint/bikes/$bikeId'),
        body: jsonEncode(<String, dynamic>{'km': km}));
    return HttpResponse(response);
  }
}
