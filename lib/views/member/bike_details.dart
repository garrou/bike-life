import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/components.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
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
  Components? components;

  void _loadComponents() async {
    dynamic jsonComponents =
        await _bikeRepository.getComponents(widget.bike.id);
    setState(() {
      components = Components.fromJson(jsonComponents);
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
        AppTopLeftButton(callback: () => Navigator.pop(context)),
        Center(child: Text(widget.bike.name, style: secondTextStyle)),
        _buildPercentBar(
            'Cadre', components!.frameKm, components!.frameDuration),
        _buildPercentBar(
            'Fourche', components!.forkKm, components!.forkDuration),
        _buildPercentBar(
            'Chaîne', components!.stringKm, components!.stringDuration),
        _buildPercentBar('Transmission', components!.transmissionKm,
            components!.transmissionDuration),
        _buildPercentBar('Roue avant', components!.wheelForwardKm,
            components!.wheelForwardDuration),
        _buildPercentBar('Roue arrière', components!.wheelBackwardKm,
            components!.wheelBackwardDuration),
        _buildPercentBar('Pneu avant', components!.tireForwardKm,
            components!.tireForwardDuration),
        _buildPercentBar('Pneu arrière', components!.tireBackwardKm,
            components!.tireBackwardDuration),
        _buildPercentBar('Chambre à air avant', components!.airChamberForwardKm,
            components!.airChamberForwardDuration),
        _buildPercentBar(
            'Chambre à air arrière',
            components!.airChamberBackwardKm,
            components!.airChamberBackwardDuration),
        _buildPercentBar('Frein avant', components!.brakeForwardKm,
            components!.brakeForwardDuration),
        _buildPercentBar('Frein arrière', components!.brakeBackwardKm,
            components!.brakeBackwardDuration),
        AppButton(text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
      ]));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  void _onDeleteBike() async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.deleteBike(widget.bike.id);
    bool deleted = response[0];
    dynamic jsonResponse = response[1];

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
      Navigator.pushNamed(context, '/tips');
    }
  }

  Widget _buildPercentBar(String label, double km, double duration) => Padding(
      padding: const EdgeInsets.only(top: thirdSize),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(label, style: thirdTextStyle),
          LinearPercentIndicator(
              center:
                  Text(components != null ? km.toString() + " km" : "0.0 km"),
              lineHeight: secondSize,
              linearStrokeCap: LinearStrokeCap.roundAll,
              percent: components != null ? km / duration : 0.0,
              backgroundColor: mainColor,
              progressColor: Colors.amber)
        ],
      ));
}
