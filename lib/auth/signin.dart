import 'package:bike_life/auth/signup.dart';
import 'package:bike_life/user/account_bottom_bar.dart';
import 'package:bike_life/constants.dart';
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

  Padding wideLayout() {
    return Padding(
        padding: const EdgeInsets.only(top: paddingTop),
        child: Center(
            child: Column(children: const <Widget>[
          BuildTitle(),
          BuildForm(),
          LinkSignup()
        ])));
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
        padding: const EdgeInsets.all(thirdSize),
        child: Text('Se connecter', style: mainTextStyle));
  }
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

  Padding buildEmailField() {
    return Padding(
        padding: const EdgeInsets.all(thirdSize),
        child: TextFormField(
            focusNode: _emailFocus,
            controller: _email,
            style: const TextStyle(color: mainColor),
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.email,
                    color: _emailFocus.hasFocus ? secondColor : mainColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
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
                focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
                prefixIcon: Icon(Icons.lock,
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(mainSize),
                    borderSide: const BorderSide(color: secondColor)),
                labelText: 'Mot de passe',
                labelStyle: TextStyle(
                    color: _passwordFocus.hasFocus ? secondColor : mainColor),
                hintText: 'Entrer un mot de passe valide'),
            cursorColor: mainColor,
            validator: (value) {
              if (value == null || value.isEmpty || value.length < 8) {
                return 'Mot de passe invalide';
              }
            },
            onSaved: (value) => {}));
  }

  ElevatedButton buildSigninButton() {
    return ElevatedButton(
        onPressed: () => _onSignin(),
        child: Text('Connexion', style: secondTextStyle),
        style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(mainColor),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(thirdSize),
                    side: const BorderSide(color: secondColor)))));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _keyForm,
        child: Column(children: <Widget>[
          buildEmailField(),
          buildPasswordField(),
          buildSigninButton()
        ]));
  }

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      // TODO: Auth
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => const AccountBottomBarPage()));
    }
  }
}

class LinkSignup extends StatelessWidget {
  const LinkSignup({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
        padding: const EdgeInsets.all(mainSize),
        child: InkWell(
            child: const Text("Nouveau ? Créer un compte",
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: secondSize)),
            onTap: () => Navigator.push(context,
                MaterialPageRoute(builder: (context) => const SignupPage()))));
  }
}
