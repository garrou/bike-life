import 'package:bike_life/constants.dart';
import 'package:bike_life/models/component.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: <
          Widget>[
        AppTopLeftButton(callback: () => Navigator.of(context).pop()),
        Center(child: Text(widget.component.label, style: secondTextStyle)),
        Padding(
            child:
                Text('Marque : ${widget.component.brand ?? "Non spécifiée"}'),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child:
                Text('Durée moyenne de vie : ${widget.component.duration} km'),
            padding: const EdgeInsets.only(top: thirdSize)),
        Padding(
            child: Text('Nombre de kilomètres : ${widget.component.km} km'),
            padding: const EdgeInsets.only(top: thirdSize))
      ]));
}
