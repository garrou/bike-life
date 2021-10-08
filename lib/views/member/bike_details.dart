import 'package:bike_life/constants.dart';
import 'package:bike_life/models/bike.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/round_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class BikeDetails extends StatelessWidget {
  final Bike bike;
  const BikeDetails({Key? key, required this.bike}) : super(key: key);

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

  Widget wideLayout() {
    return Column(children: <Widget>[
      const ButtonsBackAndDelete(),
      BikeImage(bike: bike),
      AppTitle(text: bike.name, paddingTop: 0),
      BikeDescription(bike: bike)
    ]);
  }
}

class BikeImage extends StatelessWidget {
  final Bike bike;
  const BikeImage({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Image.network(bike.image));
  }
}

class BikeDescription extends StatelessWidget {
  final Bike bike;
  const BikeDescription({Key? key, required this.bike}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text(bike.details, style: thirdTextStyle));
  }
}

class ButtonsBackAndDelete extends StatelessWidget {
  const ButtonsBackAndDelete({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          AppRoundButton(
              icon: Icons.arrow_back,
              callback: () => Navigator.of(context).pop(),
              color: mainColor),
          AppRoundButton(
              icon: Icons.delete_forever,
              callback: _onDelete,
              color: Theme.of(context).errorColor),
        ]);
  }

  void _onDelete() {
    // TODO: Delete bike
  }
}
