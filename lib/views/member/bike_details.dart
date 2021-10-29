import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/account_button.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:bike_life/views/widgets/top_right_button.dart';
import 'package:flutter/material.dart';

class BikeDetailsPage extends StatefulWidget {
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeDetailsPageState createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage> {
  final BikeRepository _bikeRepository = BikeRepository();

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
              AppTopLeftButton(
                  title: 'Paramètres du vélo',
                  callback: () => Navigator.pop(context)),
              AppTopRightButton(
                  callback: () {}, icon: Icons.help, padding: secondSize)
            ]),
        AppAccountButton(
            text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
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
}
