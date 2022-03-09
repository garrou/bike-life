import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:lottie/lottie.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IntroductionScreen(
          key: introKey,
          pages: <PageViewModel>[
            PageViewModel(
                title: 'Gestion de vos vélos',
                body: """
Ajouter vos vélos dans l'application.
Notez les dates de changements de composants.
Suivez l'utilisation de vos composants.
Soyez informé quand un composant doit-être changé.
                 """,
                image: Lottie.network(manageLogo)),
            PageViewModel(
                title: 'Une démarche écologique',
                body: 'Entretenir son vélo, un premier pas pour la planète',
                image: Lottie.network(envLogo)),
            PageViewModel(
                title: 'Une démarche économique',
                body: 'Entretenir son vélo, pour le garder plus longtemps',
                image: Lottie.network(pigLogo))
          ],
          showSkipButton: true,
          skip: const Text('Passer', style: TextStyle(color: primaryColor)),
          next: const Icon(Icons.arrow_forward, color: primaryColor),
          done: const Text('Compris', style: TextStyle(color: primaryColor)),
          curve: Curves.easeIn,
          dotsDecorator: const DotsDecorator(
            size: Size(secondSize, secondSize),
            color: primaryColor,
            activeColor: primaryColor,
            activeSize: Size(firstSize, secondSize),
            activeShape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(firstSize)),
            ),
          ),
          onDone: () => _onIntroEnd(context),
          onSkip: () => _onIntroEnd(context),
        ),
      );
}
