import 'package:bike_life/models/component_change.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/change_component.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';

class ComponentHistoricPage extends StatefulWidget {
  final Component component;
  const ComponentHistoricPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentHistoricPageState createState() => _ComponentHistoricPageState();
}

class _ComponentHistoricPageState extends State<ComponentHistoricPage> {
  late Future<List<ComponentChange>> _historic;

  Future<List<ComponentChange>> _load() async {
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
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.restart_alt, color: Colors.white),
            backgroundColor: primaryColor,
            onPressed: () => _onComponentChangePage(widget.component)),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => Padding(
        padding: const EdgeInsets.all(15),
        child: Column(
          children: <Widget>[
            AppTopLeftButton(
                title: '${widget.component.type} : changements',
                callback: _back),
            _buildList()
          ],
        ),
      );

  FutureBuilder _buildList() => FutureBuilder<List<ComponentChange>>(
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

  ListTile _buildTile(ComponentChange change) => ListTile(
      title: Text(change.changeAt),
      subtitle: Text('${change.km.toStringAsFixed(2)} km'));

  void _back() => Navigator.pop(context);

  void _onComponentChangePage(Component component) => Navigator.push(
      context, animationRightLeft(ChangeComponentPage(component: component)));
}
