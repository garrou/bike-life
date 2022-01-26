import 'package:bike_life/models/tip.dart';
import 'package:bike_life/views/member/tip_details.dart';
import 'package:flutter/material.dart';

class AppTipCard extends StatelessWidget {
  final Tip tip;
  const AppTipCard({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => TipDetailsPage(tip: tip))),
      child: Card(
        child: ListTile(title: Text(tip.title), subtitle: Text(tip.writeDate)),
      ));
}
