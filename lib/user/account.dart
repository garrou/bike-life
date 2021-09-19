import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

final List bikeList = [
  {
    "name": "Rockrider",
    "image":
        "https://media.alltricks.com/medium/2128588613b0b36614520.18988153.jpg?frz-v=298",
    "details": "VTT de descente pour se vautrer"
  },
  {
    "name": "Trek",
    "image":
        "https://media.alltricks.com/medium/18289255f917c33c11fe3.92156231.jpg?frz-v=298",
    "details": "VTT de Flo pour draguer une certaine minette"
  }
];

class AccountPage extends StatefulWidget {
  const AccountPage({Key? key}) : super(key: key);

  @override
  _AccountPageState createState() => _AccountPageState();
}

class _AccountPageState extends State<AccountPage> {
  List<Bike> _bikes = [];

  @override
  void initState() {
    super.initState();
    _bikes = createSeveralBikes(bikeList);
  }

  @override
  Widget build(BuildContext context) {
    return ListView(
        children: <Widget>[for (Bike bike in _bikes) BikeTile(bike: bike)]);
  }
}

class BikeTile extends StatelessWidget {
  final Bike bike;
  const BikeTile({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
        leading: Image.network(bike.image),
        title: Text(bike.name),
        subtitle: Text(bike.details),
        onTap: () => Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => BikeDetails(bike: bike))));
  }
}

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Center(
            child: Padding(
                padding: const EdgeInsets.only(top: paddingSize),
                child: Column(children: [
                  Image.network(bike.image),
                  Text(bike.name, style: GoogleFonts.acme(fontSize: 30.0)),
                  Text(bike.details, style: GoogleFonts.acme(fontSize: 20.0))
                ]))));
  }
}
