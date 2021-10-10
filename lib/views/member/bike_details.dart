import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/styles/rounded_button_style.dart';
import 'package:bike_life/views/widgets/back_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class BikeDetails extends StatelessWidget {
  final Member member;
  final Bike bike;
  const BikeDetails({Key? key, required this.bike, required this.member})
      : super(key: key);

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

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  SingleChildScrollView wideLayout() {
    return SingleChildScrollView(
        child: Column(children: <Widget>[
      ButtonBack(member: member),
      AppTitle(text: bike.name, paddingTop: 0),
      BikeImage(image: bike.image),
      BikeDescription(description: bike.description),
      Row(mainAxisAlignment: MainAxisAlignment.spaceAround, children: <Widget>[
        ElevatedButton(
            onPressed: null,
            child: const Icon(Icons.add),
            style: roundedButtonStyle(mainColor)),
        ElevatedButton(
            onPressed: null,
            child: const Icon(Icons.border_color_outlined),
            style: roundedButtonStyle(mainColor)),
        ElevatedButton(
            onPressed: null,
            child: const Icon(Icons.delete_forever),
            style: roundedButtonStyle(mainColor))
      ])
    ]));
  }

  void _deleteBike() async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.deleteBike(bike.id);
    bool deleted = response[0];
    dynamic jsonResponse = response[1];

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
      Navigator.pop(context);
    }
  }
}

class BikeImage extends StatelessWidget {
  final String image;
  const BikeImage({Key? key, required this.image}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize), child: Image.network(image));
  }
}

class BikeDescription extends StatelessWidget {
  final String description;
  const BikeDescription({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text(description, style: secondTextStyle));
  }
}

class ButtonBack extends StatelessWidget {
  final Member member;
  const ButtonBack({Key? key, required this.member}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AppBackButton(
        callback: () => Navigator.pushNamed(context, MemberHomeRoute.routeName,
            arguments: MemberArgument(member)));
  }
}
