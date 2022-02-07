import 'package:bike_life/models/change.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';

class ComponentDetailsPage extends StatefulWidget {
  final Component component;
  const ComponentDetailsPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentDetailsPageState createState() => _ComponentDetailsPageState();
}

class _ComponentDetailsPageState extends State<ComponentDetailsPage> {
  late Future<List<Change>> _historic;

  Future<List<Change>> _load() async {
    final ComponentService componentService = ComponentService();
    HttpResponse response =
        await componentService.getChangeHistoric(widget.component.id);

    if (response.success()) {
      return createChanges(response.body());
    } else {
      throw Exception('Erreur durant la récupération des données');
    }
  }

  @override
  void initState() {
    super.initState();
    _historic = _load();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => Padding(
      padding: const EdgeInsets.all(15),
      child: Column(children: <Widget>[
        AppTopLeftButton(title: 'Historique de changement', callback: _back),
        _buildList()
      ]));

  FutureBuilder _buildList() => FutureBuilder<List<Change>>(
      future: _historic,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (_, index) => _buildTile(snapshot.data![index]));
        }
        return const AppLoading();
      });

  ListTile _buildTile(Change change) => ListTile(
      title: Text(change.changeAt),
      subtitle: Text('${change.km.toString()} km'));

  void _back() => Navigator.push(
      context, animationRightLeft(const MemberHomePage(initialPage: 0)));
}
