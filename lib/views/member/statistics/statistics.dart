import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/providers/year_provider.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/charts/bar_chart.dart';
import 'package:bike_life/widgets/charts/pie_chart.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

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
      Column(
        children: [
          Expanded(
            child: GridView.count(
              controller: ScrollController(),
              crossAxisCount: constraints.maxWidth > maxWidth + 400
                  ? 3
                  : constraints.maxWidth > maxWidth
                      ? 2
                      : 1,
              children: const <Widget>[
                TotalChanges(),
                SumPriceComponent(),
                AveragePercentChanges(),
                AverageKmBeforeChange(),
                NbComponentsChangeYear(),
              ],
            ),
          ),
          Card(
            child: Column(
              children: <Widget>[
                Text('Année des statistiques (${context.watch<Year>().value})',
                    style: secondTextStyle),
                Slider(
                    value: context.watch<Year>().value.toDouble(),
                    thumbColor: primaryColor,
                    activeColor: primaryColor,
                    inactiveColor: const Color.fromARGB(255, 52, 160, 164),
                    min: 2020,
                    max: DateTime.now().year.toDouble(),
                    divisions: DateTime.now().year - 2020,
                    label: '${context.watch<Year>().value}',
                    onChanged: (rating) =>
                        Provider.of<Year>(context, listen: false).value =
                            rating.toInt())
              ],
            ),
          ),
        ],
      );
}

class TotalChanges extends StatefulWidget {
  const TotalChanges({Key? key}) : super(key: key);

  @override
  _TotalChangesState createState() => _TotalChangesState();
}

class _TotalChangesState extends State<TotalChanges>
    with TickerProviderStateMixin {
  late final Future<List<ComponentStat>> _totalChangeStats;
  late final AnimationController _controller;

  Future<List<ComponentStat>> _loadTotalChanges() async {
    final HttpResponse response = await ComponentService().getTotalChanges();

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  void initState() {
    super.initState();
    _totalChangeStats = _loadTotalChanges();
    _controller = AnimationController(vsync: this);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _totalChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const AppError(message: 'Problème de connexion');
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Center(
                  child: Column(children: <Widget>[
                    Lottie.asset('assets/empty.json',
                        height: 300,
                        width: 300,
                        fit: BoxFit.fill,
                        controller: _controller, onLoaded: (composition) {
                      _controller
                        ..duration = composition.duration
                        ..forward();
                    }),
                    Padding(
                      child: Text(
                        'Aucune statistique disponible pour le moment',
                        style: secondTextStyle,
                        textAlign: TextAlign.center,
                      ),
                      padding:
                          const EdgeInsets.symmetric(horizontal: secondSize),
                    )
                  ]),
                )
              : AppPieChart(
                  series: snapshot.data!, text: 'Composants changés par année');
        }
        return const AppLoading();
      });
}

class NbComponentsChangeYear extends StatelessWidget {
  const NbComponentsChangeYear({Key? key}) : super(key: key);

  Future<List<ComponentStat>> _loadNbChangeByYear(int year) async {
    final HttpResponse response =
        await ComponentService().getNbComponentsChangeStats(year);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _loadNbChangeByYear(context.watch<Year>().value),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          final String s = snapshot.data!.length > 1 ? 's' : '';
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 24, 78, 119),
                  text:
                      'Composant$s changé$s (${context.watch<Year>().value})');
        }
        return const AppLoading();
      });
}

class AverageKmBeforeChange extends StatelessWidget {
  const AverageKmBeforeChange({Key? key}) : super(key: key);

  Future<List<ComponentStat>> _loadKmChangeByYear(int year) async {
    final HttpResponse response =
        await ComponentService().getKmComponentsChangeStats(year);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _loadKmChangeByYear(context.watch<Year>().value),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 26, 117, 159),
                  text:
                      'Km moyens avant remplacement (${context.watch<Year>().value})');
        }
        return const AppLoading();
      });
}

class AveragePercentChanges extends StatelessWidget {
  const AveragePercentChanges({Key? key}) : super(key: key);

  Future<List<ComponentStat>> _loadAvgPercents() async {
    final HttpResponse response =
        await ComponentService().getAvgPercentsChanges();

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _loadAvgPercents(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  series: snapshot.data!,
                  color: const Color.fromARGB(255, 22, 138, 173),
                  text: 'Utilisation des composants avant changement (%)');
        }
        return const AppLoading();
      });
}

class SumPriceComponent extends StatelessWidget {
  const SumPriceComponent({Key? key}) : super(key: key);

  Future<List<ComponentStat>> _loadSumPrice() async {
    final HttpResponse response =
        await ComponentService().getSumPriceComponentsMember();

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _loadSumPrice(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Container();
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? Container()
              : AppBarChart(
                  vertical: true,
                  series: snapshot.data!,
                  text: 'Sommes dépensés en composants par année',
                  color: const Color.fromARGB(255, 3, 139, 139));
        }
        return const AppLoading();
      });
}
