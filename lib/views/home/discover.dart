import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:introduction_screen/introduction_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class DiscoverPage extends StatefulWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  _DiscoverPageState createState() => _DiscoverPageState();
}

class _DiscoverPageState extends State<DiscoverPage> {
  final _introKey = GlobalKey<IntroductionScreenState>();

  void _onIntroEnd(BuildContext context) => Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (BuildContext context) => const HomePage()),
      (Route<dynamic> route) => false);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: IntroductionScreen(
          key: _introKey,
          pages: <PageViewModel>[
            PageViewModel(
              title: 'Gestion de vos vélos',
              body: """
Un service permettant de gérer l'utilisation des composants de votre vélo... mais pas que.
                 """,
              image: Padding(
                child: SvgPicture.asset('assets/manage.svg'),
                padding: const EdgeInsets.all(secondSize),
              ),
            ),
            PageViewModel(
              title: 'Une démarche écologique',
              body: """
Profitez d'un suivi de l'utilisation de votre vélo, de ses composants. 
Prendre soin de son vélo, une garantie de le garder longtemps et en bon état mais aussi de moins le remplacer.
Un bon point pour votre tirelire mais également pour la planète !
                      """,
              image: Padding(
                child: SvgPicture.asset('assets/environment.svg'),
                padding: const EdgeInsets.all(secondSize),
              ),
            ),
            PageViewModel(
              title: 'Une démarche économique',
              body:
                  "Ayez un suivi de l'utilisation de votre vélo, de l'usure des composants et de votre budget vélo au fil des années.",
              image: Padding(
                child: SvgPicture.asset('assets/credit_card.svg'),
                padding: const EdgeInsets.all(secondSize),
              ),
            ),
            PageViewModel(
              title: 'Un service adapté à toutes et à tous',
              body: "Ce service est disponible sur le web, android et windows.",
              image:
                  Image.asset('assets/logo_png.png', height: 300, width: 300),
              footer: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  IconButton(
                    onPressed: () => _launch(
                      Uri.parse('https://bikeslife.fr'),
                    ),
                    color: primaryColor,
                    icon: const Icon(
                      Icons.web_outlined,
                      size: firstSize,
                    ),
                  ),
                  IconButton(
                    onPressed: () => _launch(
                      Uri.parse(
                          'https://github.com/1-irdA/bike-life/releases/tag/v1.0.0_android'),
                    ),
                    color: primaryColor,
                    icon: const Icon(Icons.android_outlined, size: firstSize),
                  ),
                  IconButton(
                    onPressed: () => _launch(
                      Uri.parse(
                          'https://github.com/1-irdA/bike-life/releases/tag/v1.0.0_windows'),
                    ),
                    color: primaryColor,
                    icon: const Icon(Icons.laptop_outlined, size: firstSize),
                  )
                ],
              ),
            )
          ],
          showSkipButton: true,
          skip: const Text('Passer', style: TextStyle(color: primaryColor)),
          next: const Icon(Icons.arrow_forward_outlined, color: primaryColor),
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

  Future<void> _launch(Uri url) async {
    if (!await launchUrl(
      url,
      mode: LaunchMode.externalApplication,
    )) {
      showErrorSnackBar(context, "Impossible d'accéder à $url");
    }
  }
}
