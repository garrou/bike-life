import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.yellow,
      child: const Center(child: Text("Screen 2")),
    );
  }
}

Future<http.Response> fetchAlbum() {
  return http.get(Uri.parse(devServer));
}
