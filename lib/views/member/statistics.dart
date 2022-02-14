import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/widgets/bar_chart.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final int _maxYear = DateTime.now().year;
  late Future<List<dynamic>> _nbChangeStats;
  late Future<List<dynamic>> _kmChangeStats;
  late int _year = _maxYear;

  Future<List<dynamic>> _loadNbStatsChange(int year) async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getNbComponentsChangeStats(memberId, year);

    if (response.success()) {
      return response.body();
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  Future<List<dynamic>> _loadKmStatsChange(int year) async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getKmComponentsChangeStats(memberId, year);

    if (response.success()) {
      return response.body();
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    _nbChangeStats = _loadNbStatsChange(_maxYear);
    _kmChangeStats = _loadKmStatsChange(_maxYear);
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 12),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) =>
      ListView(padding: const EdgeInsets.all(thirdSize), children: <Widget>[
        Card(
          child: Column(
            children: [
              Text('Année des statistiques', style: thirdTextStyle),
              Slider(
                value: _year.toDouble(),
                thumbColor: primaryColor,
                activeColor: primaryColor,
                inactiveColor: const Color.fromARGB(255, 156, 156, 156),
                min: 2010,
                max: _maxYear.toDouble(),
                divisions: _maxYear - 2010,
                label: '$_year',
                onChanged: (rating) {
                  setState(() {
                    _year = rating.toInt();
                    _nbChangeStats = _loadNbStatsChange(_year);
                    _kmChangeStats = _loadKmStatsChange(_year);
                  });
                },
              ),
            ],
          ),
        ),
        _nbComponentsChangedYear(),
        _kmComponentsChangedYear()
      ]);

  FutureBuilder _nbComponentsChangedYear() => FutureBuilder<List<dynamic>>(
      future: _nbChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<ComponentStat> stats = snapshot.data!
              .map((e) =>
                  ComponentStat(e['fk_component_type'], double.parse(e['num'])))
              .toList();
          final String s = stats.length > 1 ? 's' : '';
          return AppBarChart(
              series: stats, text: 'Composant$s changé$s en $_year');
        }
        return const AppLoading();
      });

  FutureBuilder _kmComponentsChangedYear() => FutureBuilder<List<dynamic>>(
      future: _kmChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final List<ComponentStat> stats = snapshot.data!
              .map((e) => ComponentStat(
                  e['fk_component_type'], double.parse(e['average'])))
              .toList();
          return AppBarChart(
              series: stats,
              text: 'Moyenne des kilomètres avant remplacement en $_year');
        }
        return const AppLoading();
      });
}
