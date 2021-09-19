import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ShopPage extends StatelessWidget {
  const ShopPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(children: const <Widget>[BuildTitle()]),
      ),
    );
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text("Marketplace", style: mainTextStyle));
  }
}

Future<http.Response> fetch() {
  return http.get(Uri.parse(devServer));
}
