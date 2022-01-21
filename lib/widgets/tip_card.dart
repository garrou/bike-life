import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';

class AppTipCard extends StatelessWidget {
  final Tip tip;
  const AppTipCard({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) => Center(
          child: Card(
              child: Column(mainAxisSize: MainAxisSize.min, children: <Widget>[
        ListTile(
          leading: const Icon(Icons.help, color: mainColor),
          title: Text(tip.title),
        ),
        Row(mainAxisAlignment: MainAxisAlignment.end, children: <Widget>[
          TextButton(
              child: const Icon(Icons.thumb_up),
              onPressed: () {
                // TODO: vote up
              }),
          const SizedBox(width: 8),
          TextButton(
            child: const Icon(Icons.thumb_down, color: Colors.red),
            onPressed: () {
              // TODO: vote down
            },
          ),
          const SizedBox(width: 8),
        ])
      ])));
}
