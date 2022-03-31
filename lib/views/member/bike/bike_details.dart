import 'package:bike_life/models/bike.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/bike/bike_components.dart';
import 'package:bike_life/views/member/bike/bike_diagnostic.dart';
import 'package:bike_life/views/member/bike/bike_settings.dart';
import 'package:bike_life/views/member/bike/bike_stats.dart';
import 'package:flutter/material.dart';

class BikeDetailsPage extends StatelessWidget {
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: Text(bike.name),
            bottom: const TabBar(
              indicatorColor: primaryColor,
              tabs: [
                Tab(icon: Icon(Icons.amp_stories_outlined)),
                Tab(icon: Icon(Icons.bar_chart)),
                Tab(icon: Icon(Icons.checklist_outlined)),
                Tab(icon: Icon(Icons.settings)),
              ],
            ),
          ),
          body: TabBarView(children: [
            BikeComponentsPage(bike: bike),
            BikeStatsPage(bike: bike),
            BikeDiagnosticPage(bike: bike),
            BikeSettingsPage(bike: bike)
          ]),
        ),
      );
}
