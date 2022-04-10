import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/member_home.dart';
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

  final MemberService _memberService = MemberService();

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
          child: Column(
            children: <Widget>[
              AppTitle(text: "S'inscrire", paddingTop: 0, style: mainTextStyle),
              Form(
                key: _keyForm,
                child: Column(
                  children: <Widget>[
                    AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        hintText: 'Entrer un email valide',
                        focusNode: _emailFocus,
                        textfieldController: _email,
                        validator: emailValidator,
                        icon: Icons.alternate_email),
                    AppTextField(
                        keyboardType: TextInputType.text,
                        label: 'Mot de passe',
                        hintText:
                            'Mot de passe, $minPasswordSize caractères minimum',
                        focusNode: _passwordFocus,
                        textfieldController: _password,
                        validator: passwordValidator,
                        obscureText: true,
                        icon: Icons.password),
                    AppTextField(
                        keyboardType: TextInputType.text,
                        label: 'Confirmer le mot de passe',
                        hintText:
                            'Mot de passe, $minPasswordSize caractères minimum',
                        focusNode: _confirmPasswordFocus,
                        textfieldController: _confirmPassword,
                        // ignore: body_might_complete_normally_nullable
                        validator: (value) {
                          if (_password.text != value || value!.isEmpty) {
                            return 'Mot de passe incorrect';
                          }
                        },
                        obscureText: true,
                        icon: Icons.password),
                    AppButton(
                        text: "S'inscrire",
                        callback: () => _onSignup(context),
                        icon: const Icon(Icons.person_add_alt_1))
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
            horizontal: MediaQuery.of(context).size.width / 8),
        child: wideLayout(),
      );

  void _onSignup(BuildContext context) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(context);
    }
  }

  void _createUser(BuildContext context) async {
    final HttpResponse response =
        await _memberService.signup(_email.text, _password.text);

    if (response.success()) {
      Navigator.pushAndRemoveUntil(
          context,
          animationRightLeft(const SigninPage()),
          (Route<dynamic> route) => false);
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
