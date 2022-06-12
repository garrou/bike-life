import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/models/repair.dart';
import 'package:bike_life/services/repair_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/views/member/bike/components/component_repair.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class ComponentHistoricRepairsPage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ComponentHistoricRepairsPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  State<ComponentHistoricRepairsPage> createState() =>
      _ComponentHistoricRepairsPageState();
}

class _ComponentHistoricRepairsPageState
    extends State<ComponentHistoricRepairsPage> {
  late final Future<List<Repair>> _repairs;

  Future<List<Repair>> _load() async {
    final HttpResponse response =
        await RepairService().getRepairs(widget.component.id);

    if (response.success()) {
      return createRepairs(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  void initState() {
    super.initState();
    _repairs = _load();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add_outlined, color: Colors.white),
        backgroundColor: primaryColor,
        onPressed: () => push(
            context,
            ComponentRepairPage(
                component: widget.component, bike: widget.bike)),
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
      child: _wideLayout());

  Widget _wideLayout() => Padding(
        padding: const EdgeInsets.all(15),
        child: FutureBuilder<List<Repair>>(
            future: _repairs,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppError(message: 'Problème de connexion');
              } else if (snapshot.hasData) {
                final int nb = snapshot.data!.length;
                final String s = nb > 1 ? 's' : '';

                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      child: Text('$nb réparation$s', style: thirdTextStyle),
                      padding: const EdgeInsets.all(thirdSize),
                    ),
                    Column(
                      children: <Widget>[
                        for (Repair repair in snapshot.data!) _buildCard(repair)
                      ],
                    )
                  ],
                );
              }
              return const AppLoading();
            }),
      );

  Card _buildCard(Repair repair) => Card(
        elevation: 10,
        child: Column(
          children: <Widget>[
            ListTile(
              title: Text(
                repair.formatRepairAt(),
                style: setBoldStyle(context, intermediateSize),
              ),
              subtitle: Text(
                repair.reason,
                style: setStyle(context, intermediateSize),
              ),
              trailing: Text(
                repair.formatPrice(),
                style: setStyle(context, intermediateSize),
              ),
            )
          ],
        ),
      );
}
