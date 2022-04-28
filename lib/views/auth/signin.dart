import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/views/auth/signup.dart';
import 'package:bike_life/views/member/member_home.dart';
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
              AppTitle(
                  text: 'Se connecter', paddingTop: 0, style: mainTextStyle),
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
              AppLinkToPage(
                padding: firstSize,
                child: Text('Nouveau ? Créer un compte', style: linkStyle),
                destination: const SignupPage(),
              )
            ],
          ),
        ),
      );

  Padding narrowLayout(BuildContext context) => Padding(
        padding: EdgeInsets.symmetric(
            horizontal: MediaQuery.of(context).size.width / 8),
        child: wideLayout(),
      );

  void _onSignin(BuildContext context) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(context);
    }
  }

  void _authUser(BuildContext context) async {
    final HttpResponse response =
        await _memberService.login(_email.text.trim(), _password.text.trim());

    if (response.success()) {
      Storage.setString('jwt', response.token());
      pushAndRemove(context, const MemberHomePage());
    } else {
      _password.text = '';
      showErrorSnackBar(context, response.message());
    }
  }
}
