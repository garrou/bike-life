import 'dart:async';

import 'package:bike_life/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    _checkIfLogged();
  }

  void _checkIfLogged() async {
    int memberId = await Storage.getMemberId();
    memberId != -1 ? _authState.add(true) : _authState.add(false);
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return narrowLayout();
        } else {
          return wideLayout();
        }
      })),
      signedOut: const SigninPage());

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: const <Widget>[
            AppTitle(text: 'Conseils', paddingTop: secondSize)
          ]);
}
