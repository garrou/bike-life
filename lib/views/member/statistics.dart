import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/widgets/pie_chart.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:flutter/material.dart';

class StatisticsPage extends StatefulWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  _StatisticsPageState createState() => _StatisticsPageState();
}

class _StatisticsPageState extends State<StatisticsPage> {
  late Future<List<dynamic>> _changeStats;

  Future<List<dynamic>> _loadStatsChange() async {
    final ComponentService componentService = ComponentService();
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await componentService.getComponentsChangeStats(memberId, 2022);

    if (response.success()) {
      return response.body();
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  void initState() {
    super.initState();
    _changeStats = _loadStatsChange();
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: FutureBuilder<List<dynamic>>(
          future: _changeStats,
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Text('${snapshot.error}');
            } else if (snapshot.hasData) {
              final List<ChangeSerie> series = snapshot.data!
                  .map((e) =>
                      ChangeSerie(e['fk_component_type'], int.parse(e['num'])))
                  .toList();
              return AppPieChart(data: series);
            }
            return const AppLoading();
          }));
}

class ChangeSerie {
  final String label;
  final int number;

  ChangeSerie(this.label, this.number);
}
