import 'package:bike_life/views/member/statistics.dart';
import 'package:flutter/material.dart';
import 'package:charts_flutter/flutter.dart' as charts;

class AppPieChart extends StatelessWidget {
  final List<ChangeSerie> data;
  const AppPieChart({Key? key, required this.data}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ChangeSerie, String>> series = [
      charts.Series(
        id: "changes",
        data: data,
        domainFn: (ChangeSerie series, _) => series.label,
        measureFn: (ChangeSerie series, _) => series.number,
      )
    ];

    return Padding(
        padding: const EdgeInsets.all(32.0),
        child: SizedBox(
            height: 200.0, child: charts.PieChart(series, animate: true)));
  }
}
