import 'package:bike_life/constants.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/views/forms/update_bike_component_form.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';

class ComponentDetailPage extends StatefulWidget {
  final Component component;
  const ComponentDetailPage({Key? key, required this.component})
      : super(key: key);

  @override
  _ComponentDetailPageState createState() => _ComponentDetailPageState();
}

class _ComponentDetailPageState extends State<ComponentDetailPage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return narrowLayout();
        } else {
          return wideLayout();
        }
      }));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        AppTopLeftButton(
            title: widget.component.label,
            callback: () => Navigator.of(context).pop()),
        _buildComponentsInfo(widget.component),
        const Divider(
          color: Colors.black,
          height: mainSize,
        ),
        UpdateBikeComponentForm(component: widget.component)
      ]));

  Widget _buildComponentsInfo(Component component) => Column(children: <Widget>[
        Padding(
            child: Text('Marque : ${component.brand ?? "Non spécifiée"}',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('Durée moyenne de km : ${component.duration} km',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('Nombre de kilomètres : ${component.km} km',
                style: thirdTextStyle),
            padding: const EdgeInsets.only(top: thirdSize))
      ]);
}
