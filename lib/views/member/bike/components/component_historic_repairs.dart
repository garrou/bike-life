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
  late Future<List<Repair>> _repairs;

  Future<List<Repair>> _load() async {
    final HttpResponse response =
        await RepairService().getRepairs(widget.component.id);

    print(response.body());

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
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: primaryColor,
          onPressed: () => push(
              context,
              ComponentRepairPage(
                  component: widget.component, bike: widget.bike)),
        ),
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
        child: FutureBuilder<List<Repair>>(
            future: _repairs,
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return const AppError(message: 'Erreur serveur');
              } else if (snapshot.hasData) {
                final int nb = snapshot.data!.length;
                final String s = nb > 1 ? 's' : '';

                return Column(
                  children: [
                    Padding(
                        child: Text(
                          '$nb réparation$s',
                          style: thirdTextStyle,
                        ),
                        padding: const EdgeInsets.all(10.0)),
                    Flexible(
                      child: ListView.builder(
                        itemCount: nb,
                        shrinkWrap: true,
                        itemBuilder: (_, index) =>
                            _buildCard(snapshot.data![index]),
                      ),
                    ),
                  ],
                );
              }
              return const AppLoading();
            }),
      );

  Card _buildCard(Repair repair) => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Padding(
                child: Text(repair.formatRepairAt(),
                    style: setBoldStyle(context, 18)),
                padding: const EdgeInsets.only(bottom: 5),
              ),
              Padding(
                child: Text(
                  repair.reason,
                  style: setStyle(context, 16),
                ),
                padding: const EdgeInsets.only(bottom: 5),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 5),
                child: Text('Prix : ${repair.formatPrice()}',
                    style: setStyle(context, 16)),
              ),
            ],
          ),
        ),
      );
}
