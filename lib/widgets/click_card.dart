import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:flutter/material.dart';

class AppClickCard extends StatelessWidget {
  final String text;
  final Widget destination;
  final Icon icon;
  const AppClickCard(
      {Key? key,
      required this.text,
      required this.destination,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        child: GestureDetector(
          child: ListTile(
            leading: AppClickRegion(child: icon),
            title: AppClickRegion(child: Text(text, style: secondTextStyle)),
          ),
          onTap: () => Navigator.push(
            context,
            animationRightLeft(destination),
          ),
        ),
      );
}
