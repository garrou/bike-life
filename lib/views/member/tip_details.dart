import 'dart:async';

import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class TipDetailsPage extends StatefulWidget {
  final Tip tip;
  const TipDetailsPage({Key? key, required this.tip}) : super(key: key);

  @override
  _TipDetailsPageState createState() => _TipDetailsPageState();
}

class _TipDetailsPageState extends State<TipDetailsPage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxWidth) {
              return _narrowLayout(context);
            } else {
              return _wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout());

  Widget _wideLayout() => ListView(
          padding: const EdgeInsets.symmetric(horizontal: thirdSize),
          children: <Widget>[
            AppTopLeftButton(title: 'Conseils', callback: () => _back),
            buildText(widget.tip.title, boldSubTitleStyle, TextAlign.center),
            buildText(widget.tip.content, thirdTextStyle, TextAlign.center),
          ]);

  Padding buildText(String text, TextStyle style, TextAlign textAlign) =>
      Padding(
          padding: const EdgeInsets.symmetric(vertical: thirdSize),
          child: Text(text, textAlign: textAlign, style: style));

  void _back() => Navigator.pop(context);
}
