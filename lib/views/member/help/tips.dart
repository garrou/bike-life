import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/help/tip_details.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  String _topic = '%';

  @override
  void initState() {
    super.initState();
  }

  Future<List<Tip>> _loadTips(String topic) async {
    final HttpResponse response = await TipService().getByTopic(topic);

    if (response.success()) {
      return createTips(response.body());
    } else {
      throw Exception(response.message());
    }
  }

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

  Widget _wideLayout(BuildContext context) => FutureBuilder<List<Tip>>(
      future: _loadTips(_topic),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const AppError(message: 'Erreur serveur');
        } else if (snapshot.hasData) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              _buildDropdownButton(),
              Expanded(
                child: ListView(children: <Widget>[
                  for (Tip tip in snapshot.data!) _buildTip(tip)
                ]),
              )
            ],
          );
        }
        return const AppLoading();
      });

  Widget _buildTip(Tip tip) => Card(
        child: InkWell(
          onTap: () => push(context, TipDetailsPage(tip: tip)),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5.0, 10.0, 5.0, 10.0),
            child: Column(children: <Widget>[
              Padding(
                padding: const EdgeInsets.only(bottom: 5.0),
                child: Text(tip.componentType ?? 'Vélo', style: boldTextStyle),
              ),
              Text(tip.title, style: secondTextStyle),
            ]),
          ),
        ),
      );

  Widget _buildDropdownButton() => DropdownButton<String>(
        value: _topic,
        icon: const Icon(Icons.arrow_drop_down),
        elevation: 16,
        onChanged: (String? newValue) {
          setState(() => _topic = newValue!);
        },
        items: <String>[
          'Tout',
          'Chaîne',
          'Batterie',
          'Pneus',
          'Freins',
          'Plaquettes',
          'Dérailleurs',
          'Cassette',
          'Transmission'
        ].map<DropdownMenuItem<String>>((String value) {
          return DropdownMenuItem<String>(
            value: value == 'Tout' ? '%' : value,
            child: Text(value),
          );
        }).toList(),
      );
}
