import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';

class TipDetailsPage extends StatelessWidget {
  final Tip tip;
  const TipDetailsPage({Key? key, required this.tip}) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => ListView(
          padding: const EdgeInsets.symmetric(horizontal: thirdSize),
          children: <Widget>[
            AppTopLeftButton(title: 'Conseils', callback: () => _back(context)),
            buildText(tip.title, boldSubTitleStyle, TextAlign.center),
            buildText(tip.content, thirdTextStyle, TextAlign.center),
          ]);

  Padding buildText(String text, TextStyle style, TextAlign textAlign) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: thirdSize),
          child: Text(text, textAlign: textAlign, style: style));

  void _back(BuildContext context) => Navigator.pop(context);
}
