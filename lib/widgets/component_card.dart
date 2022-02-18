import 'package:bike_life/models/component.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/member/component_historic.dart';
import 'package:bike_life/widgets/click_region.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppComponentCard extends StatelessWidget {
  final Component component;
  const AppComponentCard({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => _onComponentHistoricPage(context),
        child: AppClickRegion(
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Column(
                children: <Widget>[
                  Padding(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(component.type, style: setStyle(context, 18)),
                        Text(
                          component.formatDate(),
                          style: setStyle(context, 16),
                        )
                      ],
                    ),
                    padding: const EdgeInsets.all(10),
                  ),
                  Padding(
                      child: _buildPercentBar(context),
                      padding: const EdgeInsets.all(10)),
                  IntrinsicHeight(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        Column(
                          children: [
                            Text(component.formatKm(),
                                style: setStyle(context, 15)),
                            Text('Parcourus', style: setStyle(context, 13))
                          ],
                        ),
                        const VerticalDivider(thickness: 2, width: 2),
                        Column(
                          children: [
                            Text('${component.duration}',
                                style: setStyle(context, 15)),
                            Text('Kilomètres max', style: setStyle(context, 13))
                          ],
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      );

  Widget _buildPercentBar(BuildContext context) {
    final double percent = component.totalKm / component.duration;
    final double value = percent > 1.0
        ? 1
        : percent < 0
            ? 0
            : percent;

    return AppClickRegion(
      child: GestureDetector(
        onTap: () => _onComponentHistoricPage(context),
        child: LinearPercentIndicator(
          lineHeight: firstSize,
          center: Text(
            '${(percent * 100).toStringAsFixed(0)} %',
            style: const TextStyle(color: Colors.white),
          ),
          percent: value,
          backgroundColor: grey,
          progressColor: percent >= 1
              ? red
              : percent > .5
                  ? orange
                  : green,
          barRadius: const Radius.circular(50),
        ),
      ),
    );
  }

  void _onComponentHistoricPage(BuildContext context) => Navigator.push(
      context, animationRightLeft(ComponentHistoricPage(component: component)));
}
