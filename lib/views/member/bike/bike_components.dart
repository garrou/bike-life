import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/bike/components/component_details.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BikeComponentsPage extends StatefulWidget {
  final Bike bike;
  const BikeComponentsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeComponentsPageState createState() => _BikeComponentsPageState();
}

class _BikeComponentsPageState extends State<BikeComponentsPage> {
  late Future<List<Component>> _components;

  @override
  void initState() {
    super.initState();
    _components = _loadComponents();
  }

  Future<List<Component>> _loadComponents() async {
    final HttpResponse response =
        await ComponentService().getBikeComponents(widget.bike.id);

    if (response.success()) {
      return createComponents(response.body());
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
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => FutureBuilder<List<Component>>(
      future: _components,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const AppError(message: 'Erreur serveur');
        } else if (snapshot.hasData) {
          return ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (_, index) => AppComponentCard(
                    component: snapshot.data![index],
                    bike: widget.bike,
                  ));
        }
        return const AppLoading();
      });
}

class AppComponentCard extends StatelessWidget {
  final Component component;
  final Bike bike;
  const AppComponentCard(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        child: InkWell(
          onTap: () => _onComponentDetailsPage(context),
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Column(
              children: <Widget>[
                Padding(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(component.type, style: setStyle(context, 18)),
                      Text(
                        component.formatDate(),
                        style: setStyle(context, 16),
                      )
                    ],
                  ),
                  padding: const EdgeInsets.all(10),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        component.brand,
                        style: setStyle(context, 14),
                      ),
                      Text(
                        component.formatPrice(),
                        style: setStyle(context, 14),
                      ),
                    ],
                  ),
                ),
                Padding(
                    child: _buildPercentBar(context),
                    padding: const EdgeInsets.all(10)),
                IntrinsicHeight(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          Text(component.formatKm(),
                              style: setStyle(context, 15)),
                          Text('Parcourus', style: setStyle(context, 13))
                        ],
                      ),
                      const VerticalDivider(thickness: 2, width: 2),
                      Column(
                        children: <Widget>[
                          Text('${component.duration}',
                              style: setStyle(context, 15)),
                          Text('Kilomètres max', style: setStyle(context, 13))
                        ],
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      );

  Widget _buildPercentBar(BuildContext context) {
    final double percent = component.totalKm / component.duration;
    final double value = percent > 1.0
        ? 1
        : percent < 0
            ? 0
            : percent;

    return LinearPercentIndicator(
      lineHeight: firstSize,
      center: Text(
        '${(percent * 100).toStringAsFixed(0)} %',
        style: const TextStyle(color: Colors.white),
      ),
      percent: value,
      backgroundColor: grey,
      progressColor: percent >= 1
          ? red
          : percent > .5
              ? orange
              : green,
      barRadius: const Radius.circular(50),
    );
  }

  void _onComponentDetailsPage(BuildContext context) => Navigator.push(
        context,
        animationRightLeft(
          ComponentDetailsPage(bike: bike, component: component),
        ),
      );
}
