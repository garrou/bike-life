import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class BikeRepository {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<List<dynamic>> addBike(int memberId, String name, String urlImage,
      String dateOfPurchase, double nbKm) async {
    Response response = await client.post(
      Uri.parse('$endpoint/bikes'),
      body: jsonEncode(<String, dynamic>{
        'memberId': memberId,
        'name': name,
        'image': urlImage,
        'dateOfPurchase': dateOfPurchase,
        'nbKm': nbKm
      }),
    );
    return [response.statusCode == httpCodeCreated, jsonDecode(response.body)];
  }

  Future<dynamic> getBikes(int memberId) async {
    Response response =
        await client.get(Uri.parse('$endpoint/bikes?memberId=$memberId'));
    return jsonDecode(response.body);
  }

  Future<List<dynamic>> deleteBike(int bikeId) async {
    Response response =
        await client.delete(Uri.parse('$endpoint/bikes/$bikeId'));
    return [response.statusCode == httpCodeOk, jsonDecode(response.body)];
  }

  Future<List<dynamic>> updateBike(Bike bike) async {
    Response response = await client.put(
        Uri.parse('$endpoint/bikes/${bike.id}'),
        body: jsonEncode(<String, dynamic>{'bike': jsonEncode(bike)}));
    return [response.statusCode == httpCodeOk, jsonDecode(response.body)];
  }

  Future<List<dynamic>> updateBikeKm(int bikeId, double kmToAdd) async {
    Response response = await client.patch(Uri.parse('$endpoint/bikes/$bikeId'),
        body: jsonEncode(<String, dynamic>{'bikeId': bikeId, 'km': kmToAdd}));
    return [response.statusCode == httpCodeOk, jsonDecode(response.body)];
  }

  Future<dynamic> getComponents(int bikeId) async {
    Response response =
        await client.get(Uri.parse('$endpoint/components/$bikeId'));
    return jsonDecode(response.body);
  }

  Future<dynamic> updateComponent(Component component) async {
    Response response = await client.put(
        Uri.parse('$endpoint/components/${component.id}'),
        body:
            jsonEncode(<String, dynamic>{'component': jsonEncode(component)}));
    return [response.statusCode == httpCodeOk, jsonDecode(response.body)];
  }
}
