import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/bike_repository.dart';
import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/views/member/all_components.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/back_button.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/nav_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class BikeDetailsPage extends StatefulWidget {
  final Member member;
  final Bike bike;
  const BikeDetailsPage({Key? key, required this.bike, required this.member})
      : super(key: key);

  @override
  _BikeDetailsPageState createState() => _BikeDetailsPageState();
}

class _BikeDetailsPageState extends State<BikeDetailsPage> {
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
      AppBackButton(
          callback: () => Navigator.pushNamed(
              context, MemberHomeRoute.routeName,
              arguments: MemberArgument(widget.member))),
      AppTitle(text: widget.bike.name, paddingTop: 0.0),
      BikeImage(image: widget.bike.image),
      BikeDescription(description: widget.bike.description),
      Column(children: <Widget>[
        AppNavButton(
            text: 'Composants',
            destination: AllComponentsPage(member: widget.member),
            color: mainColor),
        AppButton(text: 'Supprimer', callback: _onDeleteBike, color: errorColor)
      ])
    ]));
  }

  void _onDeleteBike() async {
    BikeRepository bikeRepository = BikeRepository();
    List<dynamic> response = await bikeRepository.deleteBike(widget.bike.id);
    bool deleted = response[0];
    dynamic jsonResponse = response[1];

    if (deleted) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
      Navigator.pushNamed(context, MemberHomeRoute.routeName,
          arguments: MemberArgument(widget.member));
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
