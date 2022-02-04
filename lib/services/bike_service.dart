import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class BikeService {
  final Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> create(String memberId, Bike bike) async {
    return await client.post(Uri.parse('$endpoint/members/$memberId/bikes'),
        body: jsonEncode(bike));
  }

  Future<Response> getOne(String bikeId) async {
    return await client.get(Uri.parse('$endpoint/bikes/$bikeId'));
  }

  Future<Response> getByMember(String memberId) async {
    return await client.get(Uri.parse('$endpoint/members/$memberId/bikes'));
  }

  Future<Response> delete(String bikeId) async {
    return await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
  }

  Future<Response> update(Bike bike) async {
    return await client.put(Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
  }
}
