import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppBarChart extends StatelessWidget {
  final String text;
  final List<ComponentStat> series;
  const AppBarChart({Key? key, required this.series, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ComponentStat, String>> data = [
      charts.Series(
          id: "Stats",
          data: series,
          domainFn: (ComponentStat series, _) => series.label,
          measureFn: (ComponentStat series, _) => series.value,
          colorFn: (_, __) => charts.MaterialPalette.green.shadeDefault)
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height / 2,
      width: MediaQuery.of(context).size.width / 2,
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Text(text, style: thirdTextStyle),
            Expanded(
                child: charts.BarChart(data, animate: true, vertical: false))
          ],
        ),
      ),
    );
  }
}
