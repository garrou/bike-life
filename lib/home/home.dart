import 'package:bike_life/auth/signin.dart';
import 'package:bike_life/auth/signup.dart';
import 'package:bike_life/constants.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraint) {
        if (constraint.maxWidth > maxSize) {
          return narrowLayout();
        } else {
          return wideLayout();
        }
      },
    ));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Padding wideLayout() {
    return Padding(
        padding: const EdgeInsets.only(top: paddingTop),
        child: ListView(children: <Widget>[
          Center(
              child: Column(
            children: const <Widget>[
              BuildTitle(),
              BuildQuote(),
              BuildImage(),
              BuildSigninButton(),
              BuildSignupButton()
            ],
          ))
        ]));
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Text(title, style: mainTextStyle));
  }
}

class BuildQuote extends StatelessWidget {
  const BuildQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: Text(quote, style: italicTextStyle));
  }
}

class BuildImage extends StatelessWidget {
  const BuildImage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const Padding(
        padding: EdgeInsets.all(thirdSize),
        child: Image(
            image: AssetImage('assets/bike.png'),
            height: imageSize,
            width: imageSize));
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
    return Padding(
      padding: const EdgeInsets.only(top: thirdSize),
      child: ElevatedButton(
          onPressed: () => _toSigninPage(),
          child: Text("Se connecter", style: secondTextStyle),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(thirdSize),
                      side: const BorderSide(color: secondColor))))),
    );
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
    return Padding(
      padding: const EdgeInsets.only(top: thirdSize),
      child: ElevatedButton(
          onPressed: () => Navigator.push(context,
              MaterialPageRoute(builder: (context) => const SignupPage())),
          child: Text("S'inscrire", style: secondTextStyle),
          style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all<Color>(mainColor),
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(thirdSize),
                      side: const BorderSide(color: secondColor))))),
    );
  }
}
