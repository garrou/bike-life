import 'package:bike_life/models/component_change.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/bike/components/component_change.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
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
    final HttpResponse response =
        await ComponentService().getChangeHistoric(widget.component.id);

    if (response.success()) {
      return createChanges(response.body());
    } else {
      throw Exception(response.message());
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
            FutureBuilder<List<ComponentChange>>(
                future: _historic,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return const AppError(
                        message: 'Erreur de connexion avec le serveur');
                  } else if (snapshot.hasData) {
                    final int nb = snapshot.data!.length;
                    final String s = nb > 1 ? 's' : '';

                    return Column(children: [
                      ListView.builder(
                          itemCount: nb,
                          shrinkWrap: true,
                          itemBuilder: (_, index) =>
                              _buildCard(snapshot.data![index])),
                      Padding(
                          child: Text(
                            '${snapshot.data!.length} changement$s',
                            style: thirdTextStyle,
                          ),
                          padding: const EdgeInsets.all(10.0)),
                    ]);
                  }
                  return const AppLoading();
                })
          ],
        ),
      );

  Card _buildCard(ComponentChange change) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(change.brand, style: setBoldStyle(context, 18)),
                padding: const EdgeInsets.only(bottom: 5),
              ),
              Padding(
                  child: Text(
                    'Date de changement : ${change.formatChangedAt()}',
                    style: setStyle(context, 16),
                  ),
                  padding: const EdgeInsets.only(bottom: 5)),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('Parcourus : ${change.formatKm()} km',
                      style: setStyle(context, 16))),
              Padding(
                  padding: const EdgeInsets.only(bottom: 5),
                  child: Text('Prix du composant : ${change.formatPrice()} €',
                      style: setStyle(context, 16))),
            ],
          ),
        ),
      );

  void _onComponentChangePage(Component component) => Navigator.push(
      context, animationRightLeft(ChangeComponentPage(component: component)));
}
