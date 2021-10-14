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

  Padding narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Column wideLayout() => Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const AppTitle(text: title, paddingTop: 0),
          appQuote(),
          const AppNavButton(
              text: 'Se connecter',
              destination: SigninPage(),
              color: mainColor),
          const AppNavButton(
              text: "S'inscrire", destination: SignupPage(), color: mainColor)
        ],
      );

  Padding appQuote() => Padding(
      padding: const EdgeInsets.symmetric(vertical: thirdSize),
      child: Text(quote, style: italicTextStyle));
}
