import 'package:bike_life/constants.dart';
import 'package:bike_life/views/forms/signin_form.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class SigninPage extends StatelessWidget {
  const SigninPage({Key? key}) : super(key: key);

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

  Center wideLayout() => Center(
          child: SingleChildScrollView(
              child: Column(children: <Widget>[
        const AppTitle(text: 'Se connecter', paddingTop: 0),
        const AppCard(child: SigninForm(), elevation: secondSize),
        AppLinkToPage(
            padding: mainSize,
            child: Text('Nouveau ? Créer un compte', style: linkStyle),
            destination: const SignupPage())
      ])));

  Padding narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());
}
