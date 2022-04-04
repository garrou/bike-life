import 'package:bike_life/models/component.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/bike/components/component_historic.dart';
import 'package:bike_life/views/member/bike/components/component_settings.dart';
import 'package:flutter/material.dart';

class ComponentDetailsPage extends StatelessWidget {
  final Component component;
  const ComponentDetailsPage({Key? key, required this.component})
      : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(component.type),
            bottom: const TabBar(
              indicatorColor: primaryColor,
              tabs: [
                Tab(icon: Icon(Icons.history)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(children: [
            ComponentHistoricPage(component: component),
            ComponentSettingsPage(component: component),
          ]),
        ),
      );
}
