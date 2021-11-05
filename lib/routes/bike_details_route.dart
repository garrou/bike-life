import 'package:bike_life/routes/args/bike_argument.dart';
import 'package:bike_life/views/member/bike_details.dart';
import 'package:flutter/material.dart';

class BikeDetailsRoute extends StatelessWidget {
  static const routeName = '/bike';

  const BikeDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as BikeArgument;
    return BikeDetailsPage(bike: args.bike);
  }
}
