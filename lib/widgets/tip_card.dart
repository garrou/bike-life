import 'package:bike_life/models/tip.dart';
import 'package:bike_life/routes/args/tip_argument.dart';
import 'package:bike_life/routes/tip_details_route.dart';
import 'package:flutter/material.dart';

class AppTipCard extends StatelessWidget {
  final Tip tip;
  const AppTipCard({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => Navigator.pushNamed(context, TipDetailsRoute.routeName,
          arguments: TipArgument(tip)),
      child: Card(
        child: ListTile(title: Text(tip.title), subtitle: Text(tip.writeDate)),
      ));
}
