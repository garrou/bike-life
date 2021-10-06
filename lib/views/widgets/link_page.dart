import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

class AppLinkToPage extends StatelessWidget {
  final String text;
  final Widget destination;
  const AppLinkToPage({Key? key, required this.text, required this.destination})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(mainSize),
        child: InkWell(
            child: Text(text,
                style: const TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: secondSize)),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => destination))));
  }
}
