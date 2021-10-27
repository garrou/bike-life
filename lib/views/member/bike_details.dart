import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/views/member/component_details.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:bike_life/views/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

class BikeDetails extends StatefulWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeDetailsState createState() => _BikeDetailsState();
}

class _BikeDetailsState extends State<BikeDetails> {
  final BikeRepository _bikeRepository = BikeRepository();
  List<Component> components = [];

  void _loadComponents() async {
    dynamic jsonComponents =
        await _bikeRepository.getComponents(widget.bike.id);
    setState(() {
      components = [
        Component.fromJson(jsonComponents, 'frame', 'Cadre'),
        Component.fromJson(jsonComponents, 'fork', 'Fourche'),
        Component.fromJson(jsonComponents, 'string', 'Chaîne'),
        Component.fromJson(
            jsonComponents, 'air_chamber_forward', 'Chambre à air avant'),
        Component.fromJson(
            jsonComponents, 'air_chamber_backward', 'Chambre à air arrière'),
        Component.fromJson(jsonComponents, 'brake_forward', 'Frein avant'),
        Component.fromJson(jsonComponents, 'brake_backward', 'Frein arrière'),
        Component.fromJson(jsonComponents, 'tire_forward', 'Pneu avant'),
        Component.fromJson(jsonComponents, 'tire_backward', 'Pneu arrière'),
        Component.fromJson(jsonComponents, 'transmission', 'Transmission'),
        Component.fromJson(jsonComponents, 'wheel_forward', 'Roue avant'),
        Component.fromJson(jsonComponents, 'wheel_backward', 'Roue arrière')
      ];
    });
  }

  @override
  void initState() {
    super.initState();
    _loadComponents();
  }

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

  Widget wideLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: thirdSize),
      child: ListView(children: <Widget>[
        Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              AppTopLeftButton(callback: () => Navigator.pop(context)),
              AppTopRightButton(
                  callback: () {}, icon: Icons.help, padding: secondSize)
            ]),
        Center(
            child: Text('Utilisation des composants', style: secondTextStyle)),
        for (Component component in components) _buildPercentBar(component),
        AppButton(text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
      ]));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  void _onDeleteBike() async {
    List<dynamic> response = await _bikeRepository.deleteBike(widget.bike.id);
    bool deleted = response[0];
    dynamic jsonResponse = response[1];

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
      Navigator.pushNamed(context, '/tips');
    }
  }

  Widget _buildPercentBar(Component component) => Padding(
      padding: const EdgeInsets.only(top: secondSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(child: Text(component.label, style: thirdTextStyle)),
          AppLinkToPage(
              padding: 0.0,
              child: LinearPercentIndicator(
                  center: Text(component.km.toString() + " km"),
                  lineHeight: secondSize,
                  linearStrokeCap: LinearStrokeCap.roundAll,
                  percent: component.km / component.duration,
                  backgroundColor: mainColor,
                  progressColor:
                      (component.duration - component.km) <= limitDuration
                          ? Colors.red
                          : Colors.amber),
              destination: ComponentDetailPage(component: component))
        ],
      ));
}
