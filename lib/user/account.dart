import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/user/add_bike.dart';
import 'package:flutter/material.dart';

final List bikeList = [
  {
    "name": "Cannondale",
    "image":
        "https://media.alltricks.com/medium/15040135e664c68e5b9f1.87060551.jpg?frz-v=298",
    "details":
        "VTT TOUT SUSPENDU ELECTRIQUE CANNONDALE MOTERRA 3 29'' SRAM SX EAGLE 12V BBQ"
  },
  {
    "name": "BH",
    "image":
        "https://media.alltricks.com/medium/207966460b0dea6267e91.07700740.jpg?frz-v=298",
    "details":
        "VTT TOUT SUSPENDU ÉLECTRIQUE BH ATOMX CARBON LYNX 5.5 PRO-S SHIMANO SLX / XT 12V 720 WH 29'' NOIR 2021"
  },
  {
    "name": "Trek",
    "image":
        "https://media.alltricks.com/medium/15733025ea82a4d88c7f6.42261302.jpg?frz-v=298",
    "details": "GRAVEL BIKE TREK CHECKPOINT ALR 5 SHIMANO GRX 11V 2021 TEAL"
  },
  {
    "name": "BMC",
    "image":
        "https://media.alltricks.com/medium/209144760d45110a22941.59883979.jpg?frz-v=298",
    "details":
        "VÉLO DE ROUTE BMC ROADMACHINE SEVEN SHIMANO 105 11V 700 MM BLEU PETROL 2022"
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
    return Scaffold(
      body: ListView(children: <Widget>[
        Center(child: Text("Mes vélos", style: mainTextStyle)),
        for (Bike bike in _bikes) BikeTile(bike: bike)
      ]),
      floatingActionButton: FloatingActionButton(
        backgroundColor: mainColor,
        splashColor: secondColor,
        onPressed: () => Navigator.of(context).push(_addBikeRoute()),
        tooltip: 'Ajouter un vélo',
        child: const Icon(Icons.add),
      ),
    );
  }

  Route _addBikeRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const AddBikePage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          final tween = Tween(begin: const Offset(0.0, 1.0), end: Offset.zero);
          final curvedAnimation = CurvedAnimation(
            parent: animation,
            curve: Curves.ease,
          );

          return SlideTransition(
            position: tween.animate(curvedAnimation),
            child: child,
          );
        });
  }
}

class BikeTile extends StatelessWidget {
  final Bike bike;
  const BikeTile({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => Navigator.of(context).push(_bikeDetailsRoute()),
        child: Card(
          margin: const EdgeInsets.all(thirdSize),
          elevation: thirdSize,
          child: ListTile(
              leading: Image.network(bike.image),
              title: Text(bike.name),
              subtitle: Text(bike.details)),
        ));
  }

  Route _bikeDetailsRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            BikeDetails(bike: bike),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
              position: animation.drive(
                  Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                      .chain(CurveTween(curve: Curves.easeInOut))),
              child: child);
        });
  }
}

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text(bike.name), backgroundColor: mainColor),
        body: Center(
            child: Column(children: [
          Padding(
              padding: const EdgeInsets.all(thirdSize),
              child: Image.network(bike.image)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: thirdSize),
              child: Text(bike.name, style: mainTextStyle)),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: thirdSize),
              child: Text(bike.details, style: thirdTextStyle))
        ])));
  }
}
