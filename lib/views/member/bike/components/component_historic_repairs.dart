import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/views/member/bike/components/component_repair.dart';
import 'package:flutter/material.dart';

class ComponentHistoricRepairsPage extends StatefulWidget {
  final Component component;
  final Bike bike;
  const ComponentHistoricRepairsPage(
      {Key? key, required this.component, required this.bike})
      : super(key: key);

  @override
  State<ComponentHistoricRepairsPage> createState() =>
      _ComponentHistoricRepairsPageState();
}

class _ComponentHistoricRepairsPageState
    extends State<ComponentHistoricRepairsPage> {
  @override
  Widget build(BuildContext context) => Scaffold(
        floatingActionButton: FloatingActionButton(
          child: const Icon(Icons.add, color: Colors.white),
          backgroundColor: primaryColor,
          onPressed: () => push(
              context,
              ComponentRepairPage(
                  component: widget.component, bike: widget.bike)),
        ),
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => Column(
        children: [
          Padding(
              child: Text(
                '0 réparations',
                style: thirdTextStyle,
              ),
              padding: const EdgeInsets.all(10.0)),
          Flexible(
            child: ListView.builder(
              itemCount: 0,
              shrinkWrap: true,
              itemBuilder: (_, index) => _buildCard(),
            ),
          ),
        ],
      );

  Card _buildCard() => Card(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            children: [],
          ),
        ),
      );
}
