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

  Future<HttpResponse> create(String memberId, Bike bike) async {
    Response response = await client.post(
        Uri.parse('$endpoint/members/$memberId/bikes'),
        body: jsonEncode(bike));
    return HttpResponse(response);
  }

  Future<HttpResponse> getOne(String bikeId) async {
    Response response = await client.get(Uri.parse('$endpoint/bikes/$bikeId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> getByMember(String memberId) async {
    Response response =
        await client.get(Uri.parse('$endpoint/members/$memberId/bikes'));
    return HttpResponse(response);
  }

  Future<HttpResponse> delete(String bikeId) async {
    Response response =
        await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
    return HttpResponse(response);
  }

  Future<HttpResponse> update(Bike bike) async {
    Response response = await client.put(
        Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
    return HttpResponse(response);
  }
}
