import 'dart:convert';

import 'package:bike_life/models/component.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/http_account_interceptor.dart';
import 'package:http/http.dart';
import 'package:http_interceptor/http/http.dart';

class ComponentService {
  Client client = InterceptedClient.build(interceptors: [
    HttpAccountInterceptor(),
  ]);

  Future<Response> getBikeComponents(int bikeId) async {
    return await client.get(Uri.parse('$endpoint/components?bikeId=$bikeId'));
  }

  Future<Response> add(String brand, String image, double km, double duration,
      String type, String date, int bikeId) async {
    return await client.post(Uri.parse('$endpoint/components'),
        body: jsonEncode(<String, dynamic>{
          'brand': brand,
          'image': image,
          'km': km,
          'duration': duration,
          'type': type,
          'date': date,
          'bikeId': bikeId
        }));
  }

  Future<Response> update(Component component) async {
    return await client.put(Uri.parse('$endpoint/components/${component.id}'),
        body:
            jsonEncode(<String, dynamic>{'component': jsonEncode(component)}));
  }
}
