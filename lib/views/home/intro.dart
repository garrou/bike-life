import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';

class IntroPage extends StatefulWidget {
  const IntroPage({Key? key}) : super(key: key);

  @override
  _IntroPageState createState() => _IntroPageState();
}

class _IntroPageState extends State<IntroPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(context) {
    Navigator.pushNamedAndRemoveUntil(
        context, '/', (Route<dynamic> route) => false);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: IntroductionScreen(
          key: introKey,
          globalBackgroundColor: Colors.white,
          pages: [
            PageViewModel(
                title: title,
                body: quote,
                image: Image.asset('assets/bike.png')),
            PageViewModel(
                title: 'Gestion de vos vélos',
                body: "Ajouter vos vélos dans l'application",
                image: const Icon(Icons.bike_scooter)),
            PageViewModel(
                title: 'Gestion des composants des vélos',
                body:
                    "Gardez un oeil sur l'utilisation de vos composants en fonction de leur durée de vie",
                image: const Icon(Icons.health_and_safety))
          ],
          showSkipButton: true,
          skip: const Text('Passer', style: TextStyle(color: mainColor)),
          next: const Icon(Icons.arrow_forward, color: mainColor),
          done: const Text('Compris', style: TextStyle(color: mainColor)),
          curve: Curves.fastLinearToSlowEaseIn,
          dotsDecorator: const DotsDecorator(
            size: Size(secondSize, secondSize),
            color: mainColor,
            activeColor: secondColor,
            activeSize: Size(mainSize, secondSize),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(mainSize)),
            ),
          ),
          onDone: () => _onIntroEnd(context)));
}
