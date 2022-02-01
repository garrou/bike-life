import 'dart:async';
import 'dart:convert';

import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/styles/theme_model.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return _narrowLayout();
            } else {
              return _wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() =>
      Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) {
        return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    AppTopLeftButton(
                        title: 'Profil',
                        callback: () => Navigator.of(context).pop()),
                    AppTopRightButton(
                        callback: _onDisconnect,
                        icon: Icons.logout,
                        color: red,
                        padding: secondSize)
                  ]),
              Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                Text('Thème', style: secondTextStyle),
                IconButton(
                  onPressed: () {
                    themeNotifier.isDark
                        ? themeNotifier.isDark = false
                        : themeNotifier.isDark = true;
                  },
                  icon: Icon(themeNotifier.isDark
                      ? Icons.nightlight_round
                      : Icons.wb_sunny),
                )
              ]),
              const UpdateAuthForm()
            ]);
      });

  void _onDisconnect() {
    Storage.disconnect();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const SigninPage()),
        (Route<dynamic> route) => false);
  }
}

class UpdateAuthForm extends StatefulWidget {
  const UpdateAuthForm({Key? key}) : super(key: key);

  @override
  _UpdateAuthFormState createState() => _UpdateAuthFormState();
}

class _UpdateAuthFormState extends State<UpdateAuthForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPassFocus = FocusNode();
  final _confirmPass = TextEditingController();

  final MemberService _memberService = MemberService();
  late Future<String> _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _load();
  }

  Future<String> _load() async {
    String id = await Storage.getMemberId();
    Response response = await _memberService.getEmail(id);

    if (response.statusCode == httpCodeOk) {
      return jsonDecode(response.body)['email'];
    } else {
      throw Exception("Impossible de récupérer l'email");
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: secondSize),
      child: Form(
          key: _keyForm,
          child: Column(children: <Widget>[
            FutureBuilder(
                future: _userEmail,
                builder: (_, snapshot) {
                  if (snapshot.hasError) {
                    return Text('${snapshot.error}');
                  } else if (snapshot.hasData) {
                    _email.text = snapshot.data.toString();
                    return AppTextField(
                        keyboardType: TextInputType.emailAddress,
                        label: 'Email',
                        hintText: 'Entrer un email valide',
                        focusNode: _emailFocus,
                        textfieldController: _email,
                        validator: emailValidator,
                        icon: Icons.alternate_email);
                  }
                  return const AppLoading();
                }),
            AppTextField(
                keyboardType: TextInputType.text,
                label: 'Mot de passe',
                hintText:
                    'Entrer un mot de passe de minimum $minPasswordSize caractères',
                focusNode: _passwordFocus,
                textfieldController: _password,
                validator: passwordValidator,
                obscureText: true,
                icon: Icons.password),
            AppTextField(
                keyboardType: TextInputType.text,
                label: 'Confirmer le mot de passe',
                hintText: 'Confirmer le mot de passe',
                focusNode: _confirmPassFocus,
                textfieldController: _confirmPass,
                validator: (value) {
                  if (_password.text != value || value!.isEmpty) {
                    return 'Mot de passe incorrect';
                  }
                },
                obscureText: true,
                icon: Icons.password),
            AppButton(
                text: 'Modifier',
                callback: _onUpdate,
                color: deepGreen,
                icon: const Icon(Icons.edit))
          ])));

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateAuth();
    }
  }

  void _updateAuth() async {
    String id = await Storage.getMemberId();
    Response response =
        await _memberService.update(id, _email.text, _password.text);
    Color color = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pop(context);
    } else {
      color = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(json['confirm']), backgroundColor: color));
  }
}
