import 'package:bike_life/routes/args/bike_argument.dart';
import 'package:bike_life/views/member/add_component.dart';
import 'package:flutter/material.dart';

class AddComponentRoute extends StatelessWidget {
  static const routeName = '/add-component';

  const AddComponentRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BikeArgument;
    return AddComponentPage(bike: args.bike);
  }
}
