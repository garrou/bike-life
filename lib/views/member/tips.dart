import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/tip_details.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final StreamController<bool> _authState = StreamController();
  final TipService _tipService = TipService();
  late Future<List<Tip>> _tips;

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _tips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    Response response = await _tipService.getByType('%');

    if (response.statusCode == httpCodeOk) {
      return createTips(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les conseils');
    }
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }),
      signedOut: const SigninPage());

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        AppTitle(
            text: 'Conseils', paddingTop: mainSize, style: secondTextStyle),
        FutureBuilder<List<Tip>>(
            future: _tips,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                return Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      for (Tip tip in snapshot.data!) _buildTip(tip)
                    ]);
              }
              return const AppLoading();
            })
      ]);

  Widget _buildTip(Tip tip) => Card(
      child: GestureDetector(
          onTap: () => Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (BuildContext context) => TipDetailsPage(tip: tip))),
          child: ListTile(
              title: MouseRegion(
                  child: Text(tip.title), cursor: SystemMouseCursors.click),
              subtitle: MouseRegion(
                  child: Text(tip.writeDate),
                  cursor: SystemMouseCursors.click))));
}
