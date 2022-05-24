import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/auth_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:bike_life/widgets/link_page.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class SigninPage extends StatefulWidget {
  const SigninPage({Key? key}) : super(key: key);

  @override
  _SigninPageState createState() => _SigninPageState();
}

class _SigninPageState extends State<SigninPage> {
  final StreamController<bool> _authState = StreamController();

  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberHomePage(),
          signedOut: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxWidth) {
              return narrowLayout(context);
            } else {
              return wideLayout();
            }
          }),
        ),
      );

  Widget wideLayout() => Center(
        child: SingleChildScrollView(
          child: AppCard(
            child: Column(
              children: <Widget>[
                AppTitle(
                    text: 'Se connecter',
                    paddingBottom: secondSize,
                    style: mainTextStyle),
                Form(
                  key: _keyForm,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      AppTextField(
                          keyboardType: TextInputType.emailAddress,
                          label: 'Email',
                          focusNode: _emailFocus,
                          textfieldController: _email,
                          validator: emailValidator,
                          icon: Icons.alternate_email),
                      AppTextField(
                          keyboardType: TextInputType.text,
                          label: 'Mot de passe',
                          focusNode: _passwordFocus,
                          textfieldController: _password,
                          validator: fieldValidator,
                          obscureText: true,
                          icon: Icons.password),
                      AppButton(
                          text: 'Connexion',
                          callback: () => _onSignin(context),
                          icon: const Icon(Icons.login))
                    ],
                  ),
                ),
                TextButton(
                  child: Text('Mot de passe oublié ?', style: linkStyle),
                  onPressed: () => _onForgotPassword(context),
                ),
                AppLinkToPage(
                  padding: thirdSize,
                  child: Text('Nouveau ? Créer un compte.', style: linkStyle),
                  destination: const SignupPage(),
                )
              ],
            ),
          ),
        ),
      );

  Padding narrowLayout(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 4),
        child: wideLayout(),
      );

  void _onSignin(BuildContext context) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(context);
    }
  }

  void _authUser(BuildContext context) async {
    try {
      final HttpResponse response =
          await AuthService().login(_email.text.trim(), _password.text.trim());

      if (response.success()) {
        Storage.setString('jwt', response.token());
        pushAndRemove(context, const MemberHomePage());
      } else {
        _password.text = '';
        showErrorSnackBar(context, response.message());
      }
    } on Exception catch (_) {
      showErrorSnackBar(context, 'Impossible de se connecter au serveur');
    }
  }

  void _onForgotPassword(BuildContext context) async {
    final _key = GlobalKey<FormState>();

    final _emailFocusFp = FocusNode();
    final _emailFp = TextEditingController();

    void _sendEmail() async {
      final HttpResponse response =
          await AuthService().forgotPassword(_emailFp.text.trim());

      if (response.success()) {
        showSuccessSnackBar(context, response.message());
      } else {
        showErrorSnackBar(context, response.message());
      }
    }

    void _onSendEmail() {
      if (_key.currentState!.validate()) {
        _key.currentState!.save();
        _sendEmail();
      }
    }

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return SimpleDialog(
            title: Text('Entrez votre adresse mail', style: thirdTextStyle),
            contentPadding: const EdgeInsets.all(firstSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(firstSize),
            ),
            children: <Widget>[
              Form(
                key: _key,
                child: Column(
                  children: [
                    AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        focusNode: _emailFocusFp,
                        textfieldController: _emailFp,
                        validator: emailValidator,
                        icon: Icons.alternate_email),
                    AppButton(
                      width: buttonWidth * 1.5,
                      text: 'Recevoir un mail de récupération',
                      callback: _onSendEmail,
                      icon: const Icon(Icons.send),
                    )
                  ],
                ),
              ),
            ],
          );
        });
  }
}
