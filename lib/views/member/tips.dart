import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatelessWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            AppTitle(text: 'Conseils', paddingTop: secondSize)
          ]);
}
