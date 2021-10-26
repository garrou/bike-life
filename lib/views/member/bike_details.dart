import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/components.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:bike_life/views/widgets/title.dart';
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

  Widget wideLayout() => Column(children: <Widget>[
        AppTopLeftButton(callback: () => Navigator.pop(context)),
        AppTitle(text: widget.bike.name, paddingTop: 0.0),
        LinearPercentIndicator(
            linearStrokeCap: LinearStrokeCap.roundAll,
            percent: components != null
                ? components!.frameKm / components!.frameDuration
                : 0.0,
            backgroundColor: mainColor,
            progressColor: Colors.amber),
        AppButton(text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
      ]);

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
}
