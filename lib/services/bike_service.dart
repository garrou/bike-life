import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';

import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class BikeService {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> addBike(String memberId, String name, String urlImage,
      String dateOfPurchase, double nbKm, bool electric) async {
    return await client.post(
      Uri.parse('$endpoint/members/$memberId/bikes'),
      body: jsonEncode(<String, dynamic>{
        'memberId': memberId,
        'name': name,
        'image': urlImage,
        'dateOfPurchase': dateOfPurchase,
        'nbKm': nbKm,
        'electric': electric
      }),
    );
  }

  Future<Response> getBike(String bikeId) async {
    return await client.get(Uri.parse('$endpoint/bikes/$bikeId'));
  }

  Future<Response> getBikes(String memberId) async {
    return await client.get(Uri.parse('$endpoint/members/$memberId/bikes'));
  }

  Future<Response> deleteBike(String bikeId) async {
    return await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
  }

  Future<Response> updateBike(Bike bike) async {
    return await client.put(Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
  }

  Future<Response> addKm(String bikeId, double kmToAdd) async {
    return await client.patch(Uri.parse('$endpoint/bikes/$bikeId'),
        body: jsonEncode(<String, dynamic>{'km': kmToAdd}));
  }
}
