import 'package:bike_life/auth/signin.dart';
import 'package:bike_life/auth/signup.dart';
import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(title, textAlign: TextAlign.center),
          backgroundColor: mainColor,
        ),
        body: LayoutBuilder(
          builder: (context, constraint) {
            return Center(
                child: Column(
              children: const <Widget>[
                BuildTitle(),
                BuildQuote(),
                BuildImage(),
                BuildSigninButton(),
                BuildSignupButton()
              ],
            ));
          },
        ));
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Text(title, style: GoogleFonts.acme(fontSize: titleSize)));
  }
}

class BuildQuote extends StatelessWidget {
  const BuildQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(paddingSize),
        child: Text('La santé de votre vélo se surveille de près.',
            style:
                GoogleFonts.acme(fontSize: 20, fontStyle: FontStyle.italic)));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(paddingSize),
        child: Image(image: AssetImage('assets/bike.png')));
  }
}

class BuildSigninButton extends StatefulWidget {
  const BuildSigninButton({Key? key}) : super(key: key);

  @override
  _BuildSigninButtonState createState() => _BuildSigninButtonState();
}

class _BuildSigninButtonState extends State<BuildSigninButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => _toSigninPage(),
        child: const Text("Se connecter"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusSize),
                    side: const BorderSide(color: secondColor)))));
  }

  void _toSigninPage() {
    Navigator.push(
        context, MaterialPageRoute(builder: (context) => const SigninPage()));
  }
}

class BuildSignupButton extends StatelessWidget {
  const BuildSignupButton({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (context) => const SignupPage())),
        child: const Text("S'inscrire"),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(radiusSize),
                    side: const BorderSide(color: secondColor)))));
  }
}
