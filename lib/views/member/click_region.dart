import 'package:flutter/material.dart';

class AppClickRegion extends StatelessWidget {
  final Widget child;
  const AppClickRegion({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MouseRegion(cursor: SystemMouseCursors.click, child: child);
  }
}
