import 'package:bike_life/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/views/member/component_details.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class AppPercentBar extends StatelessWidget {
  final Component component;
  const AppPercentBar({Key? key, required this.component}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.only(top: secondSize),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Center(child: Text(component.label, style: thirdTextStyle)),
            AppLinkToPage(
                padding: 0.0,
                child: _buildLinearPercentBar(component),
                destination: ComponentDetailPage(component: component))
          ],
        ));
  }

  Widget _buildLinearPercentBar(Component component) => LinearPercentIndicator(
      center: Text('${component.km} / ${component.duration} km',
          style: whiteThirdTextStyle),
      lineHeight: secondSize,
      linearStrokeCap: LinearStrokeCap.roundAll,
      percent: (component.km / component.duration) > 1
          ? 1.0
          : (component.km / component.duration),
      backgroundColor: Colors.grey,
      progressColor: (component.duration - component.km) <= limitDuration
          ? Colors.red
          : mainColor);
}
