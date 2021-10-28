import 'package:bike_life/models/member.dart';
import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/routes/member_home_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/widgets/textfield.dart';
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
        const AppCard(child: BuildForm(), elevation: secondSize),
        AppLinkToPage(
            padding: mainSize,
            child: Text('Nouveau ? Créer un compte', style: linkStyle),
            destination: const SignupPage())
      ])));

  Padding narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  _BuildFormState createState() => _BuildFormState();
}

class _BuildFormState extends State<BuildForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          AppTextField(
              label: 'Email',
              hintText: 'Entrer un email valide',
              focusNode: _emailFocus,
              textfieldController: _email,
              validator: emailValidator,
              icon: Icons.alternate_email),
          AppTextField(
              label: 'Mot de passe',
              hintText: 'Entrer votre mot de passe',
              focusNode: _passwordFocus,
              textfieldController: _password,
              validator: passwordValidator,
              obscureText: true,
              icon: Icons.lock),
          AppButton(text: 'Connexion', callback: _onSignin, color: mainColor)
        ]));
  }

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(_email.text, _password.text);
    }
  }

  void _authUser(String email, String password) async {
    MemberRepository memberRepository = MemberRepository();
    List<dynamic> response = await memberRepository.login(email, password);
    Member? member = response[0];
    dynamic jsonResponse = response[1];

    if (member != null) {
      Navigator.pushNamed(context, MemberHomeRoute.routeName,
          arguments: MemberArgument(member));
    } else {
      _password.text = '';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(jsonResponse['confirm']),
          backgroundColor: Theme.of(context).errorColor));
    }
  }
}
