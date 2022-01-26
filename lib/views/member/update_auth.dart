import 'dart:convert';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return _narrowLayout();
        } else {
          return _wideLayout();
        }
      }));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() => ListView(children: <Widget>[
        AppTopLeftButton(
            title: 'Modifier mon profil',
            callback: () => Navigator.of(context).pop()),
        const UpdateAuthForm()
      ]);
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

  @override
  void initState() {
    super.initState();
    _load();
  }

  void _load() async {
    String id = await Storage.getMemberId();
    Response response = await _memberService.getEmail(id);

    if (response.statusCode == httpCodeOk) {
      _email.text = jsonDecode(response.body)['email'];
    }
  }

  @override
  Widget build(BuildContext context) => Padding(
      padding: const EdgeInsets.only(top: secondSize),
      child: Form(
          key: _keyForm,
          child: Column(children: <Widget>[
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
                    'Entrer un mot de passe de minimum $minPasswordSize caractères',
                focusNode: _passwordFocus,
                textfieldController: _password,
                validator: passwordValidator,
                obscureText: true,
                icon: Icons.lock),
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
                icon: Icons.lock),
            AppButton(text: 'Modifier', callback: _onUpdate, color: deepGreen)
          ])));

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateAuth(_email.text, _password.text);
    }
  }

  void _updateAuth(String email, String password) async {
    String id = await Storage.getMemberId();
    Response response = await _memberService.update(id, email, password);
    Color responseColor = deepGreen;
    dynamic json = jsonDecode(response.body);

    if (response.statusCode == httpCodeOk) {
      Navigator.pop(context);
    } else {
      responseColor = red;
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(json['confirm']), backgroundColor: responseColor));
  }
}
