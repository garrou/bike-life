import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:bike_life/views/member/tip_details.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  late Future<List<Tip>> _tips;

  @override
  void initState() {
    super.initState();
    _tips = _loadTips();
  }

  Future<List<Tip>> _loadTips() async {
    final HttpResponse response = await TipService().getByTopic('%');

    if (response.success()) {
      return createTips(response.body());
    } else {
      throw Exception(response.message());
    }
  }

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
          padding: const EdgeInsets.fromLTRB(
              thirdSize, firstSize, thirdSize, thirdSize),
          children: <Widget>[
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Conseils', style: secondTextStyle),
            ]),
            FutureBuilder<List<Tip>>(
                future: _tips,
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return AppError(message: '${snapshot.error}');
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
        elevation: 5,
        child: GestureDetector(
          onTap: () => Navigator.push(
              context, animationRightLeft(TipDetailsPage(tip: tip))),
          child: ListTile(
            title: AppClickRegion(child: Text(tip.title)),
            subtitle: AppClickRegion(child: Text(tip.writeDate)),
          ),
        ),
      );
}
