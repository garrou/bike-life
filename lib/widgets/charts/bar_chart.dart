import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppBarChart extends StatelessWidget {
  final String text;
  final List<ComponentStat> series;
  final bool vertical;
  const AppBarChart(
      {Key? key,
      required this.series,
      required this.text,
      this.vertical = false})
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
                child: charts.BarChart(data,
                    animate: true,
                    vertical: vertical,
                    primaryMeasureAxis: charts.NumericAxisSpec(
                        renderSpec: charts.GridlineRendererSpec(
                            labelStyle: charts.TextStyleSpec(
                                color: chartColorByTheme(context)),
                            lineStyle: charts.LineStyleSpec(
                                color: chartColorByTheme(context)))),
                    domainAxis: const charts.OrdinalAxisSpec(
                        renderSpec: charts.NoneRenderSpec()),
                    barRendererDecorator: charts.BarLabelDecorator(
                        insideLabelStyleSpec: charts.TextStyleSpec(
                            color: charts.MaterialPalette.white.lighter))))
          ],
        ),
      ),
    );
  }
}