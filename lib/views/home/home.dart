import 'package:bike_life/constants.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/nav_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraint) {
      if (constraint.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Column wideLayout() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: const <Widget>[
        AppTitle(text: title, paddingTop: secondSize),
        BuildQuote(),
        AppNavButton(text: 'Se connecter', destination: SigninPage()),
        AppNavButton(text: "S'inscrire", destination: SignupPage())
      ],
    );
  }
}

class BuildQuote extends StatelessWidget {
  const BuildQuote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
        child: Padding(
            padding: const EdgeInsets.only(bottom: thirdSize),
            child: Text(quote, style: italicTextStyle)));
  }
}
