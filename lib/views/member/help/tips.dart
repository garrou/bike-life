import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/models/topic.dart';
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
  late final Future<List<Topic>> _topics;
  String _topic = '%';

  @override
  void initState() {
    super.initState();
    _topics = _loadTopics();
  }

  Future<List<Topic>> _loadTopics() async {
    final HttpResponse response = await TipService().getTopics();

    if (response.success()) {
      return createTopics(response.body());
    } else {
      throw Exception(response.message());
    }
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
          body: ListView(
        children: [
          LayoutBuilder(
            builder: (context, constraints) {
              if (constraints.maxWidth > maxWidth) {
                return _narrowLayout(context);
              } else {
                return _wideLayout(context);
              }
            },
          ),
        ],
      ));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) => FutureBuilder<List<Tip>>(
      future: _loadTips(_topic),
      builder: (_, snapshot) {
        if (snapshot.hasError) {
          return const AppError(message: 'Problème de connexion');
        } else if (snapshot.hasData) {
          return ListView(
            shrinkWrap: true,
            children: <Widget>[
              _buildDropdownButton(),
              Column(
                children: <Widget>[
                  for (Tip tip in snapshot.data!) _buildTip(tip)
                ],
              ),
            ],
          );
        }
        return const AppLoading();
      });

  Widget _buildTip(Tip tip) => ListTile(
        title: Text(
          tip.componentType ?? 'Vélo',
          style: boldTextStyle,
        ),
        subtitle: Text(tip.title, style: secondTextStyle),
        trailing: IconButton(
          icon: const Icon(Icons.keyboard_arrow_right_outlined, size: 30),
          onPressed: () => push(
            context,
            TipDetailsPage(tip: tip),
          ),
        ),
      );

  Widget _buildDropdownButton() => FutureBuilder<List<Topic>>(
      future: _topics,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Erreur de connexion');
        } else if (snapshot.hasData) {
          return Padding(
            padding: const EdgeInsets.only(top: firstSize),
            child: DropdownButton<String>(
              isExpanded: true,
              value: _topic,
              icon: const Icon(Icons.arrow_drop_down_outlined),
              elevation: 16,
              onChanged: (String? newValue) {
                setState(() => _topic = newValue!);
              },
              items:
                  snapshot.data!.map<DropdownMenuItem<String>>((Topic topic) {
                return DropdownMenuItem<String>(
                  value: topic.name == 'Tout' ? '%' : topic.name,
                  child: Text(topic.name, style: secondTextStyle),
                );
              }).toList(),
            ),
          );
        }
        return const AppLoading();
      });
}
