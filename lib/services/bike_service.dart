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

  Future<Response> addBike(int memberId, String name, String urlImage,
      String dateOfPurchase, double nbKm) async {
    return await client.post(
      Uri.parse('$endpoint/$memberId/bikes'),
      body: jsonEncode(<String, dynamic>{
        'memberId': memberId,
        'name': name,
        'image': urlImage,
        'dateOfPurchase': dateOfPurchase,
        'nbKm': nbKm
      }),
    );
  }

  Future<Response> getBikes(int memberId) async {
    return await client.get(Uri.parse('$endpoint/members/$memberId/bikes'));
  }

  Future<Response> deleteBike(int bikeId) async {
    return await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
  }

  Future<Response> updateBike(Bike bike) async {
    return await client.put(Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
  }

  Future<Response> updateBikeKm(int bikeId, double kmToAdd) async {
    return await client.patch(Uri.parse('$endpoint/bikes/$bikeId'),
        body: jsonEncode(<String, dynamic>{'bikeId': bikeId, 'km': kmToAdd}));
  }
}
