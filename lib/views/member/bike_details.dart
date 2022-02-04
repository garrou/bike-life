import 'dart:convert';

import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BikeDetailsPage extends StatefulWidget {
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeDetailsPageState createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage> {
  final ComponentService _componentService = ComponentService();
  late Future<List<Component>> _components;

  @override
  void initState() {
    super.initState();
    _components = _loadComponents();
  }

  Future<List<Component>> _loadComponents() async {
    Response response =
        await _componentService.getBikeComponents(widget.bike.id);

    if (response.statusCode == httpCodeOk) {
      return createComponents(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return _narrowLayout();
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() => ListView(children: [
        AppTopLeftButton(title: 'Composants', callback: _back),
        _buildList()
      ]);

  FutureBuilder _buildList() => FutureBuilder<List<Component>>(
      future: _components,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (_, index) {
                return _buildComponent(snapshot.data![index]);
              });
        }
        return const AppLoading();
      });

  Widget _buildComponent(Component component) => Card(
      child: ListTile(
          title: MouseRegion(
              child: Text(component.type), cursor: SystemMouseCursors.click),
          subtitle: _buildLinearPercentBar(component)));

  Widget _buildLinearPercentBar(Component component) {
    final DateTime start = DateTime.parse(widget.bike.addedAt);
    final Duration diff = DateTime.now().difference(start);
    double percent =
        diff.inDays * (widget.bike.kmPerWeek / 7) / component.duration;
    percent = percent > 1.0 ? 1 : percent;

    return MouseRegion(
        child: LinearPercentIndicator(
            lineHeight: mainSize,
            center: Text('${(percent * 100).toStringAsFixed(0)} %'),
            percent: percent,
            backgroundColor: grey,
            progressColor: percent >= 1
                ? red
                : percent > .5
                    ? orange
                    : green,
            barRadius: const Radius.circular(50)),
        cursor: SystemMouseCursors.click);
  }

  void _back() => Navigator.of(context).pop();
}
