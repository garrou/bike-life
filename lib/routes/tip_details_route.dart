import 'package:bike_life/routes/args/tip_argument.dart';
import 'package:bike_life/views/member/tip_details.dart';
import 'package:flutter/material.dart';

class TipDetailsRoute extends StatelessWidget {
  static const routeName = '/tip-details';

  const TipDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as TipArgument;
    return TipDetailsPage(tip: args.tip);
  }
}
