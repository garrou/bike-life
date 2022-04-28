import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/bike/components/component_historic_change.dart';
import 'package:bike_life/views/member/bike/components/component_historic_repairs.dart';
import 'package:bike_life/views/member/bike/components/component_settings.dart';
import 'package:flutter/material.dart';

class ComponentDetailsPage extends StatelessWidget {
  final Component component;
  final Bike bike;
  const ComponentDetailsPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(component.type),
            bottom: const TabBar(
              indicatorColor: primaryColor,
              tabs: [
                Tab(icon: Icon(Icons.history)),
                Tab(icon: Icon(Icons.auto_stories_outlined)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(children: [
            ComponentHistoricChangePage(component: component, bike: bike),
            ComponentHistoricRepairsPage(component: component, bike: bike),
            ComponentSettingsPage(component: component, bike: bike),
          ]),
        ),
      );
}
