import 'dart:convert';

import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class BikeRepository {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<List<dynamic>> addBike(int memberId, String name, String description,
      String urlImage, String dateOfPurchase, String nbKm) async {
    Response response = await client.post(
      Uri.parse('$endpoint/bikes'),
      body: jsonEncode(<String, dynamic>{
        'memberId': memberId,
        'name': name,
        'description': description,
        'image': urlImage,
        'dateOfPurchase': dateOfPurchase,
        'nbKm': nbKm
      }),
    );
    dynamic jsonResponse = jsonDecode(response.body);
    return [response.statusCode == httpCodeCreated, jsonResponse];
  }

  Future<dynamic> getBikes(int memberId) async {
    Response response =
        await client.get(Uri.parse('$endpoint/bikes?memberId=$memberId'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> deleteBike(int bikeId) async {
    Response response =
        await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
    dynamic jsonResponse = jsonDecode(response.body);
    return [response.statusCode == httpCodeOk, jsonResponse];
  }

  Future<List<dynamic>> updateBike(Bike bike) async {
    Response response = await client.put(
        Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
    dynamic jsonResponse = jsonDecode(response.body);
    return [response.statusCode == httpCodeOk, jsonResponse];
  }
}
