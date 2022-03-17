import 'package:flutter/material.dart';

class AppLinkToPage extends StatelessWidget {
  final Widget child;
  final Widget destination;
  final double padding;
  const AppLinkToPage(
      {Key? key,
      required this.child,
      required this.destination,
      this.padding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
        padding: EdgeInsets.all(padding),
        child: InkWell(
          child: child,
          onTap: () => Navigator.push(
              context, MaterialPageRoute(builder: (context) => destination)),
        ),
      );
}
