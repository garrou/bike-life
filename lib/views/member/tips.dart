import 'dart:async';

import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/tip_card.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final StreamController<bool> _authState = StreamController();
  final TipService _tipService = TipService();
  List<Tip> _tips = [];

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _load();
  }

  void _load() async {
    List<Tip> tips = await _tipService.getAll();
    setState(() => _tips = tips);
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

  Widget wideLayout() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        const AppTitle(text: 'Conseils', paddingTop: mainSize),
        for (Tip tip in _tips) AppTipCard(tip: tip)
      ]);
}
