import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/styles/theme_model.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:bike_life/widgets/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context);
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
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
                        icon: const Icon(Icons.logout),
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
                      ? Icons.nightlight_round_outlined
                      : Icons.wb_sunny),
                )
              ]),
              const ProfileForm()
            ]);
      });

  void _onDisconnect() {
    Storage.disconnect();
    Navigator.pushAndRemoveUntil(
        context,
        animationRightLeft(const SigninPage()),
        (Route<dynamic> route) => false);
  }
}

class ProfileForm extends StatefulWidget {
  const ProfileForm({Key? key}) : super(key: key);

  @override
  _ProfileFormState createState() => _ProfileFormState();
}

class _ProfileFormState extends State<ProfileForm> {
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

  // TODO: pref profile and cursor to display components
  Future<String> _load() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response = await _memberService.getEmail(memberId);

    if (response.success()) {
      return response.email();
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
                    'Entrer un mot de passe de $minPasswordSize caractères minimum',
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
                // ignore: body_might_complete_normally_nullable
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
                icon: const Icon(Icons.save))
          ])));

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateAuth();
    }
  }

  void _updateAuth() async {
    final String id = await Storage.getMemberId();
    final HttpResponse response =
        await _memberService.update(id, _email.text, _password.text);

    if (response.success()) {
      Navigator.pop(context);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message()), backgroundColor: response.color()));
  }
}
