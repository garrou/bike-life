import 'package:bike_life/auth.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_other_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/constants.dart';
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
              BuildTitle(),
              BuildForm(),
              LinkToOtherPage(
                  text: 'Déjà membre ? Se connecter', destination: SigninPage())
            ]));
  }

  Padding narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }
}

class BuildTitle extends StatelessWidget {
  const BuildTitle({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.symmetric(vertical: thirdSize),
        child: Text("S'inscrire", style: mainTextStyle));
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

  Padding buildEmailField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _emailFocus,
            controller: _email,
            style: const TextStyle(color: mainColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: focusTextfieldBorder(mainSize, secondColor),
                prefixIcon: Icon(Icons.email,
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                border: focusTextfieldBorder(mainSize, secondColor),
                labelText: 'Email',
                labelStyle: TextStyle(
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                hintText: 'Entrer un email valide'),
            cursorColor: mainColor,
            validator: (value) {
              if (value == null || value.isEmpty) {
                return 'Email invalide';
              }
            },
            onSaved: (value) => {}));
  }

  Padding buildPasswordField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _passwordFocus,
            controller: _password,
            style: const TextStyle(color: mainColor),
            obscureText: true,
            decoration: InputDecoration(
                focusedBorder: focusTextfieldBorder(mainSize, secondColor),
                prefixIcon: Icon(Icons.lock,
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                border: focusTextfieldBorder(mainSize, secondColor),
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                hintText: 'Entrer un mot de passe valide'),
            cursorColor: mainColor,
            validator: (value) {
              if (value == null ||
                  value.isEmpty ||
                  value.length < minPasswordSize) {
                return 'Mot de passe invalide';
              }
            },
            onSaved: (value) => {}));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          buildEmailField(),
          buildPasswordField(),
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
