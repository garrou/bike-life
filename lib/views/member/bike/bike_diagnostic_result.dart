import 'package:bike_life/models/tip.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/views/member/help/tip_details.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class BikeDiagnosticResultPage extends StatefulWidget {
  final List<Tip> tips;
  const BikeDiagnosticResultPage({Key? key, required this.tips})
      : super(key: key);

  @override
  State<BikeDiagnosticResultPage> createState() =>
      _BikeDiagnosticResultPageState();
}

class _BikeDiagnosticResultPageState extends State<BikeDiagnosticResultPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout(context);
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => Column(
        children: <Widget>[
          AppTopLeftButton(
            title: 'Accueil',
            callback: () => pushAndRemove(context, const MemberHomePage()),
          ),
          _buildText(),
          Expanded(
            child: ListView(
              shrinkWrap: true,
              children: <Widget>[
                for (Tip tip in widget.tips)
                  Card(
                    child: InkWell(
                      onTap: () => push(context, TipDetailsPage(tip: tip)),
                      child: Column(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(tip.title, style: boldTextStyle),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(bottom: 5.0),
                            child: Text(tip.componentType ?? 'Vélo',
                                style: thirdTextStyle),
                          ),
                        ],
                      ),
                    ),
                  )
              ],
            ),
          )
        ],
      );

  Widget _buildText() => Padding(
        padding: const EdgeInsets.fromLTRB(10, 0, 10, 10),
        child: widget.tips.isEmpty
            ? Column(
                children: <Widget>[
                  Text(
                    'Bravo ! Votre vélo est en parfaite santé !',
                    style: secondTextStyle,
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 10),
                    child:
                        Lottie.asset('assets/check.json', fit: BoxFit.contain),
                  ),
                ],
              )
            : Text(
                'Voici quelques conseils à suivre pour prendre soin de votre vélo.',
                style: secondTextStyle,
                textAlign: TextAlign.center,
              ),
      );
}
