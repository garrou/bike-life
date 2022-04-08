import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/charts/bar_chart.dart';
import 'package:bike_life/widgets/charts/pie_chart.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';

class BikeStatsPage extends StatefulWidget {
  final Bike bike;
  const BikeStatsPage({Key? key, required this.bike}) : super(key: key);

  @override
  State<BikeStatsPage> createState() => _BikeStatsPageState();
}

class _BikeStatsPageState extends State<BikeStatsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context, constraints);
          } else {
            return _wideLayout(context, constraints);
          }
        }),
      );

  Widget _narrowLayout(
          BuildContext context, BoxConstraints constraints) =>
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12),
          child: _wideLayout(context, constraints));

  Widget _wideLayout(BuildContext context, BoxConstraints constraints) =>
      Column(children: [
        Expanded(
          child: GridView.count(
            crossAxisCount: constraints.maxWidth > maxWidth + 400
                ? 3
                : constraints.maxWidth > maxWidth
                    ? 2
                    : 1,
            children: <Widget>[
              NbChangeStats(bikeId: widget.bike.id),
              SumPriceBikeComponents(bikeId: widget.bike.id),
              AvgChangeComponentsBike(bikeId: widget.bike.id),
              NbChange(bikeId: widget.bike.id),
            ],
          ),
        )
      ]);
}

class NbChangeStats extends StatefulWidget {
  final String bikeId;
  const NbChangeStats({Key? key, required this.bikeId}) : super(key: key);

  @override
  State<NbChangeStats> createState() => _NbChangeStatsState();
}

class _NbChangeStatsState extends State<NbChangeStats> {
  late Future<List<ComponentStat>> _nbChangeStats;

  @override
  void initState() {
    super.initState();
    _nbChangeStats = _loadNbChangeStatsByBike(widget.bikeId);
  }

  Future<List<ComponentStat>> _loadNbChangeStatsByBike(String bikeId) async {
    final HttpResponse response =
        await ComponentService().getNbChangesByBike(bikeId);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _nbChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? AppTitle(
                  text: 'Aucune statistique',
                  paddingTop: 10,
                  style: thirdTextStyle)
              : AppPieChart(
                  series: snapshot.data!,
                  text: 'Nombre de composants changés sur ce vélo');
        }
        return const AppLoading();
      });
}

class AvgChangeComponentsBike extends StatefulWidget {
  final String bikeId;
  const AvgChangeComponentsBike({Key? key, required this.bikeId})
      : super(key: key);

  @override
  State<AvgChangeComponentsBike> createState() =>
      _AvgChangeComponentsBikeState();
}

class _AvgChangeComponentsBikeState extends State<AvgChangeComponentsBike> {
  late Future<List<ComponentStat>> _nbChangeStats;

  @override
  void initState() {
    super.initState();
    _nbChangeStats = _loadAvgKmChangeByBike(widget.bikeId);
  }

  Future<List<ComponentStat>> _loadAvgKmChangeByBike(String bikeId) async {
    final HttpResponse response =
        await ComponentService().getAvgPercentChangesByBike(bikeId);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _nbChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 26, 117, 159),
                  text: 'Utilisation des composants avant changement (%)');
        }
        return const AppLoading();
      });
}

class NbChange extends StatefulWidget {
  final String bikeId;
  const NbChange({Key? key, required this.bikeId}) : super(key: key);

  @override
  State<NbChange> createState() => _NbChangeState();
}

class _NbChangeState extends State<NbChange> {
  late Future<List<ComponentStat>> _nbChangeStats;

  @override
  void initState() {
    super.initState();
    _nbChangeStats = _loadNumOfComponentsChange(widget.bikeId);
  }

  Future<List<ComponentStat>> _loadNumOfComponentsChange(String bikeId) async {
    final HttpResponse response =
        await ComponentService().getNumOfCompoChangedByBike(bikeId);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _nbChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 30, 96, 145),
                  text: 'Composants changés sur ce vélo par années');
        }
        return const AppLoading();
      });
}

class SumPriceBikeComponents extends StatefulWidget {
  final String bikeId;
  const SumPriceBikeComponents({Key? key, required this.bikeId})
      : super(key: key);

  @override
  State<SumPriceBikeComponents> createState() => _SumPriceBikeComponentsState();
}

class _SumPriceBikeComponentsState extends State<SumPriceBikeComponents> {
  late Future<List<ComponentStat>> _sumPriceCompoStats;

  @override
  void initState() {
    super.initState();
    _sumPriceCompoStats = _loadSumPriceBikeComponents(widget.bikeId);
  }

  Future<List<ComponentStat>> _loadSumPriceBikeComponents(String bikeId) async {
    final HttpResponse response =
        await ComponentService().getSumPriceComponentsBike(bikeId);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _sumPriceCompoStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  vertical: true,
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 3, 139, 139),
                  text: 'Sommes dépensés en composants sur ce vélo');
        }
        return const AppLoading();
      });
}
