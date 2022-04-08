import 'package:bike_life/models/component_stat.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/material.dart';

class AppBarChart extends StatelessWidget {
  final String text;
  final List<ComponentStat> series;
  final bool vertical;
  final Color color;
  const AppBarChart(
      {Key? key,
      required this.series,
      required this.text,
      required this.color,
      this.vertical = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final List<charts.Series<ComponentStat, String>> data = [
      charts.Series(
        id: "Stats",
        data: series,
        colorFn: (__, ___) => charts.ColorUtil.fromDartColor(color),
        domainFn: (ComponentStat series, _) => series.label,
        measureFn: (ComponentStat series, _) => series.value,
        labelAccessorFn: (ComponentStat series, _) =>
            '${series.label} : ${series.value.toStringAsFixed(2)}',
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
              child: Text(text, style: secondTextStyle),
            ),
            Expanded(
              child: charts.BarChart(
                data,
                animate: true,
                vertical: vertical,
                primaryMeasureAxis: const charts.NumericAxisSpec(
                    renderSpec: charts.NoneRenderSpec()),
                domainAxis: const charts.OrdinalAxisSpec(
                    renderSpec: charts.NoneRenderSpec()),
                barRendererDecorator: charts.BarLabelDecorator(
                  insideLabelStyleSpec: charts.TextStyleSpec(
                      color: charts.MaterialPalette.white.lighter),
                  outsideLabelStyleSpec: charts.TextStyleSpec(
                    color: chartColorByTheme(context),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
