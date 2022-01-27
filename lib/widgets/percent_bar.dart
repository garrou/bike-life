import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/views/member/component_details.dart';
import 'package:bike_life/styles/general.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppPercentBar extends StatelessWidget {
  final Component component;
  const AppPercentBar({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(bottom: secondSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: Text(component.type, style: thirdTextStyle)),
          GestureDetector(
              child: _buildLinearPercentBar(component),
              onTap: () => _onTap(context, component))
        ],
      ));

  Widget _buildLinearPercentBar(Component component) => LinearPercentIndicator(
      center: Text('${component.km} / ${component.duration} km',
          style: whiteThirdTextStyle),
      lineHeight: mainSize,
      linearStrokeCap: LinearStrokeCap.roundAll,
      percent: (component.km / component.duration) > 1.0
          ? 1.0
          : (component.km / component.duration),
      backgroundColor: grey,
      progressColor:
          component.km >= 0.0 && component.km < component.duration / 2
              ? greenLight
              : component.km >= component.duration / 2 &&
                      component.km < component.duration
                  ? orange
                  : red);

  void _onTap(BuildContext context, Component component) => Navigator.push(
      context,
      MaterialPageRoute(
          builder: (BuildContext context) =>
              ComponentDetailPage(component: component)));
}
