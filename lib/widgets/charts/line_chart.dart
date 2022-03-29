import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppLineChart extends StatelessWidget {
  final String text;
  final List<ComponentStat> series;
  final bool vertical;
  final Color color;
  const AppLineChart(
      {Key? key,
      required this.series,
      required this.text,
      required this.color,
      this.vertical = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ComponentStat, double>> data = [
      charts.Series(
        id: "Stats",
        data: series,
        colorFn: (__, ___) => charts.ColorUtil.fromDartColor(color),
        domainFn: (ComponentStat series, _) => series.value,
        measureFn: (ComponentStat series, _) => double.parse(series.label),
      )
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 3,
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(thirdSize),
              child: Text(text, style: fourthTextStyle),
            ),
            Expanded(
              child: charts.LineChart(
                data,
                animate: true,
              ),
            )
          ],
        ),
      ),
    );
  }
}
