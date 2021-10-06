import 'package:bike_life/auth.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class SignupPage extends StatelessWidget {
  const SignupPage({Key? key}) : super(key: key);

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

  Padding wideLayout() {
    return Padding(
        padding: const EdgeInsets.only(top: paddingTop),
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: const <Widget>[
              AppTitle(text: "S'inscrire"),
              BuildForm(),
              AppLinkToPage(
                  text: 'Déjà membre ? Se connecter', destination: SigninPage())
            ]));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<BuildForm> {
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
          AppTextfield(
              label: 'Email',
              hintText: 'Entrer un email valide',
              focusNode: _emailFocus,
              textfieldController: _email,
              validator: emailValidator,
              obscureText: false),
          AppTextfield(
              label: 'Mot de passe',
              hintText:
                  'Entrer un mot de passe avec $minPasswordSize caractères minimum',
              focusNode: _passwordFocus,
              textfieldController: _password,
              validator: emailValidator,
              obscureText: true),
          AppButton(text: "S'inscrire", callback: onSignin)
        ]));
  }

  void onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(_email.text, _password.text);
    }
  }

  void _createUser(String email, String password) async {
    final response = await signup(email, password);
    late Color statusColor;
    late String statusMsg;

    if (response.statusCode == 201) {
      statusColor = Theme.of(context).primaryColor;
      statusMsg = 'Compte créé avec succés !';
      Navigator.push(
          context, MaterialPageRoute(builder: (context) => const SigninPage()));
    } else if (response.statusCode == 409) {
      statusColor = Theme.of(context).errorColor;
      statusMsg = 'Un compte est déjà associé à cet email.';
    } else {
      statusColor = Theme.of(context).errorColor;
      statusMsg = 'Impossible de créer un compte.';
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(statusMsg), backgroundColor: statusColor));
  }
}
