import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/bike_tile.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/cupertino.dart';
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
  },
  {
    "name": "N",
    "image":
        "https://media.alltricks.com/medium/209144760d45110a22941.59883979.jpg?frz-v=298",
    "details": "VÉLO DE ROUTE"
  }
];

class AccountPage extends StatefulWidget {
  final Member member;
  const AccountPage({Key? key, required this.member}) : super(key: key);

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
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    });
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return Scaffold(
        body: ListView(children: <Widget>[
          const AppTitle(text: 'Mes vélos', paddingTop: secondSize),
          for (Bike bike in _bikes) AppBikeTile(bike: bike)
        ]),
        floatingActionButton: FloatingActionButton(
          backgroundColor: mainColor,
          splashColor: secondColor,
          onPressed: () => Navigator.of(context).push(addBikeRoute()),
          tooltip: 'Ajouter un vélo',
          child: const Icon(Icons.add),
        ));
  }

  Route addBikeRoute() {
    return PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            AddBikePage(member: widget.member),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: Tween(begin: const Offset(0.0, 1.0), end: Offset.zero)
                .animate(CurvedAnimation(
              parent: animation,
              curve: Curves.ease,
            )),
            child: child,
          );
        });
  }
}
