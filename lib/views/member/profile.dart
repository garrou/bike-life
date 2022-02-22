import 'dart:async';

import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/card.dart';
import 'package:bike_life/widgets/error.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/buttons/top_right_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

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
        return ListView(
          children: <Widget>[
            AppTopRightButton(
                onPressed: () => _onDisconnect(context),
                icon: const Icon(Icons.logout),
                color: red,
                padding: secondSize),
            AppCard(
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
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
                elevation: 5),
            const UpdateEmailForm(),
            UpdatePasswordForm()
          ],
        );
      });

  void _onDisconnect(BuildContext context) {
    Storage.disconnect();
    Navigator.pushAndRemoveUntil(
        context,
        animationRightLeft(const SigninPage()),
        (Route<dynamic> route) => false);
  }
}

class UpdateEmailForm extends StatefulWidget {
  const UpdateEmailForm({Key? key}) : super(key: key);

  @override
  _UpdateEmailFormState createState() => _UpdateEmailFormState();
}

class _UpdateEmailFormState extends State<UpdateEmailForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final MemberService _memberService = MemberService();
  late Future<String> _userEmail;

  @override
  void initState() {
    super.initState();
    _userEmail = _load();
  }

  Future<String> _load() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response = await _memberService.getEmail(memberId);

    if (response.success()) {
      return response.email();
    } else {
      throw Exception(response.message());
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: secondSize),
        child: AppCard(
          elevation: 5,
          child: Form(
            key: _keyForm,
            child: Column(
              children: <Widget>[
                Text("Modifier l'email", style: thirdTextStyle),
                FutureBuilder(
                    future: _userEmail,
                    builder: (_, snapshot) {
                      if (snapshot.hasError) {
                        return AppError(message: '${snapshot.error}');
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
                AppButton(
                    text: "Modifier",
                    callback: _onUpdate,
                    icon: const Icon(Icons.save))
              ],
            ),
          ),
        ),
      );

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateEmail();
    }
  }

  void _updateEmail() async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await _memberService.updateEmail(memberId, _email.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color()));
  }
}

class UpdatePasswordForm extends StatelessWidget {
  UpdatePasswordForm({Key? key}) : super(key: key);

  final _keyForm = GlobalKey<FormState>();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPassFocus = FocusNode();
  final _confirmPass = TextEditingController();

  @override
  Widget build(BuildContext context) => Padding(
        padding: const EdgeInsets.only(top: secondSize),
        child: AppCard(
          elevation: 5,
          child: Form(
            key: _keyForm,
            child: Column(
              children: <Widget>[
                Text('Modifier le mot de passe', style: thirdTextStyle),
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
                    text: "Modifier",
                    callback: () => _onUpdate(context),
                    icon: const Icon(Icons.save))
              ],
            ),
          ),
        ),
      );

  void _onUpdate(BuildContext context) {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updatePassword(context);
    }
  }

  void _updatePassword(BuildContext context) async {
    final String memberId = await Storage.getMemberId();
    final HttpResponse response =
        await MemberService().updatePassword(memberId, _password.text);

    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(response.message(),
            style: const TextStyle(color: Colors.white)),
        backgroundColor: response.color()));
  }
}
