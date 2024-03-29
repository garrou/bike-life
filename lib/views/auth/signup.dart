import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/auth_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/nav.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/link_page.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  _SignupPageState createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final StreamController<bool> _authState = StreamController();

  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPasswordFocus = FocusNode();
  final _confirmPassword = TextEditingController();

  @override
  void initState() {
    super.initState();
    Storage.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: AuthGuard(
          authStream: _authState.stream,
          signedIn: const MemberNav(),
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
          child: Column(
            children: <Widget>[
              Image.asset(
                'assets/logo_png.png',
                fit: BoxFit.scaleDown,
                height: 200,
                width: 200,
              ),
              AppTitle(
                  text: "S'inscrire",
                  paddingBottom: secondSize,
                  style: mainTextStyle),
              Form(
                key: _keyForm,
                child: Column(
                  children: <Widget>[
                    AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        focusNode: _emailFocus,
                        textfieldController: _email,
                        validator: emailValidator,
                        icon: Icons.alternate_email_outlined),
                    AppTextField(
                      keyboardType: TextInputType.text,
                      label:
                          'Mot de passe ($minPasswordSize caractères minimum)',
                      focusNode: _passwordFocus,
                      textfieldController: _password,
                      validator: (value) => passwordValidator(
                          value, minPasswordSize, maxPasswordSize),
                      obscureText: true,
                      icon: Icons.password_outlined,
                    ),
                    AppTextField(
                      keyboardType: TextInputType.text,
                      label: 'Confirmer le mot de passe',
                      focusNode: _confirmPasswordFocus,
                      textfieldController: _confirmPassword,
                      // ignore: body_might_complete_normally_nullable
                      validator: (value) {
                        if (_password.text != value || value!.isEmpty) {
                          return 'Mot de passe incorrect';
                        }
                      },
                      obscureText: true,
                      icon: Icons.password_outlined,
                    ),
                    AppButton(
                        text: "S'inscrire",
                        callback: () => _onSignup(context),
                        icon: const Icon(Icons.person_add_alt_1_outlined))
                  ],
                ),
              ),
              AppLinkToPage(
                padding: firstSize,
                child: Text('Déjà membre ? Se connecter', style: linkStyle),
                destination: const SigninPage(),
              ),
            ],
          ),
        ),
      );

  Padding narrowLayout(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 4),
        child: wideLayout(),
      );

  void _onSignup(BuildContext context) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(context);
    }
  }

  void _createUser(BuildContext context) async {
    try {
      final HttpResponse response = await AuthService().signup(
        _email.text.trim(),
        _password.text.trim(),
        _confirmPassword.text.trim(),
      );

      if (response.success()) {
        pushAndRemove(context, const SigninPage());
        showSuccessSnackBar(context, response.message());
      } else {
        showErrorSnackBar(context, response.message());
      }
    } on Exception catch (_) {
      showErrorSnackBar(context, 'Impossible de se connecter au serveur');
    }
  }
}
