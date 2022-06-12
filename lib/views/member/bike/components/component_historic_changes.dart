import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component_change.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/bike/components/component_change.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class ComponentHistoricChangesPage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ComponentHistoricChangesPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  _ComponentHistoricPageState createState() => _ComponentHistoricPageState();
}

class _ComponentHistoricPageState extends State<ComponentHistoricChangesPage> {
  late final Future<List<ComponentChange>> _historic;

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
        child: const Icon(Icons.add_outlined, color: Colors.white),
        backgroundColor: primaryColor,
        onPressed: () => push(
          context,
          ComponentChangePage(component: widget.component, bike: widget.bike),
        ),
      ),
      body: SingleChildScrollView(
        child: LayoutBuilder(
          builder: (context, constraints) {
            if (constraints.maxWidth > maxWidth) {
              return _narrowLayout(context);
            } else {
              return _wideLayout();
            }
          },
        ),
      ));

  Widget _narrowLayout(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        child: _wideLayout(),
      );

  Widget _wideLayout() => Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<ComponentChange>>(
            future: _historic,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppError(message: 'Problème de connexion');
              } else if (snapshot.hasData) {
                final int nb = snapshot.data!.length;
                final String s = nb > 1 ? 's' : '';

                return Column(
                  children: [
                    Padding(
                      child: Text('$nb changement$s', style: thirdTextStyle),
                      padding: const EdgeInsets.all(thirdSize),
                    ),
                    Column(
                      children: <Widget>[
                        for (ComponentChange change in snapshot.data!)
                          _buildCard(change)
                      ],
                    ),
                  ],
                );
              }
              return const AppLoading();
            }),
      );

  Widget _buildCard(ComponentChange change) => Card(
        elevation: 10,
        child: Column(
          children: [
            ListTile(
              title: Text(
                change.brand,
                style: setBoldStyle(context, intermediateSize),
              ),
            ),
            ListTile(
              title: Text(
                'Parcourus : ${change.formatKm()} km',
                style: setStyle(context, intermediateSize),
              ),
              subtitle: Text(
                'Date de changement : ${change.formatChangedAt()}',
                style: setStyle(context, intermediateSize),
              ),
              trailing: Text(
                change.formatPrice(),
                style: setStyle(context, intermediateSize),
              ),
            )
          ],
        ),
      );
}
