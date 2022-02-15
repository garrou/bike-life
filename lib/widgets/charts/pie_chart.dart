import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppPieChart extends StatelessWidget {
  final String text;
  final List<ComponentStat> series;
  const AppPieChart({Key? key, required this.series, required this.text})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ComponentStat, String>> data = [
      charts.Series(
          id: "Stats",
          data: series,
          domainFn: (ComponentStat series, _) => series.label,
          measureFn: (ComponentStat series, _) => series.value)
    ];

    return SizedBox(
      height: MediaQuery.of(context).size.height,
      width: MediaQuery.of(context).size.width / 3,
      child: Card(
        elevation: 5,
        child: Column(
          children: <Widget>[
            Text(text, style: fourthTextStyle),
            Expanded(
                child: charts.PieChart(
              data,
              animate: true,
              behaviors: [
                charts.DatumLegend<Object>(
                  entryTextStyle:
                      charts.TextStyleSpec(color: colorByTheme(context)),
                  outsideJustification: charts.OutsideJustification.middle,
                  desiredMaxColumns: 2,
                  position: charts.BehaviorPosition.start,
                  horizontalFirst: false,
                  showMeasures: true,
                  legendDefaultMeasure: charts.LegendDefaultMeasure.firstValue,
                  measureFormatter: (num? value) {
                    return ': $value';
                  },
                )
              ],
            ))
          ],
        ),
      ),
    );
  }
}
