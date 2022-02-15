import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/widgets/charts/bar_chart.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/charts/pie_chart.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  final int _maxYear = DateTime.now().year;
  late int _year = _maxYear;

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context, constraints);
        } else {
          return _wideLayout(context, constraints);
        }
      }));

  Widget _narrowLayout(
          BuildContext context, BoxConstraints constraints) =>
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12),
          child: _wideLayout(context, constraints));

  Widget _wideLayout(BuildContext context, BoxConstraints constraints) =>
      ListView(shrinkWrap: true, children: <Widget>[
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
                    setState(() => _year = rating.toInt());
                  }),
            ],
          ),
        ),
        GridView.count(
            physics: const ScrollPhysics(),
            shrinkWrap: true,
            crossAxisCount: constraints.maxWidth > maxWidth + 400
                ? 3
                : constraints.maxWidth > maxWidth
                    ? 2
                    : 1,
            children: [
              const TotalChanges(),
              NbComponentsChangeYear(year: _year),
              AverageKmBeforeChange(year: _year)
            ])
      ]);
}

class TotalChanges extends StatefulWidget {
  const TotalChanges({Key? key}) : super(key: key);

  @override
  _TotalChangesState createState() => _TotalChangesState();
}

class _TotalChangesState extends State<TotalChanges> {
  late Future<List<ComponentStat>> _totalChangeStats;

  Future<List<ComponentStat>> _loadTotalChanges() async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getTotalChanges(memberId);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    _totalChangeStats = _loadTotalChanges();
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _totalChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? AppTitle(
                  text: 'Aucune donnée', paddingTop: 10, style: thirdTextStyle)
              : AppBarChart(
                  vertical: true,
                  series: snapshot.data!,
                  text: 'Composants changés par année');
        }
        return const AppLoading();
      });
}

class NbComponentsChangeYear extends StatefulWidget {
  final int year;
  const NbComponentsChangeYear({Key? key, required this.year})
      : super(key: key);

  @override
  _ComponentsChangeYearState createState() => _ComponentsChangeYearState();
}

class _ComponentsChangeYearState extends State<NbComponentsChangeYear> {
  late Future<List<ComponentStat>> _nbChangeStats;
  late int _year;

  Future<List<ComponentStat>> _loadNbChangeByYear(int year) async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getNbComponentsChangeStats(memberId, year);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _nbChangeStats = _loadNbChangeByYear(_year);
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _nbChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          final String s = snapshot.data!.length > 1 ? 's' : '';
          return snapshot.data!.isEmpty
              ? AppTitle(
                  text: 'Aucune donnée', paddingTop: 10, style: thirdTextStyle)
              : AppPieChart(
                  series: snapshot.data!,
                  text: 'Composant$s changé$s ($_year)');
        }
        return const AppLoading();
      });
}

class AverageKmBeforeChange extends StatefulWidget {
  final int year;
  const AverageKmBeforeChange({Key? key, required this.year}) : super(key: key);

  @override
  _AverageKmBeforeChangeState createState() => _AverageKmBeforeChangeState();
}

class _AverageKmBeforeChangeState extends State<AverageKmBeforeChange> {
  late Future<List<ComponentStat>> _kmChangeStats;
  late int _year;

  @override
  void initState() {
    super.initState();
    _year = widget.year;
    _kmChangeStats = _loadKmChangeByYear(_year);
  }

  Future<List<ComponentStat>> _loadKmChangeByYear(int year) async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getKmComponentsChangeStats(memberId, year);

    if (response.success()) {
      return createComponentStats(response.body());
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  Widget build(BuildContext context) => FutureBuilder<List<ComponentStat>>(
      future: _kmChangeStats,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return snapshot.data!.isEmpty
              ? AppTitle(
                  text: 'Aucune donnée', paddingTop: 10, style: thirdTextStyle)
              : AppBarChart(
                  series: snapshot.data!,
                  text: 'Km moyens avant remplacement ($_year)');
        }
        return const AppLoading();
      });
}

class Year extends ChangeNotifier {
  int _year;

  Year(this._year);

  int get year {
    return _year;
  }

  set year(int year) {
    _year = year;
    notifyListeners();
  }
}
