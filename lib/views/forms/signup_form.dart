import 'package:bike_life/constants.dart';
import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SignupForm extends StatefulWidget {
  const SignupForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<SignupForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPasswordFocus = FocusNode();
  final _confirmPassword = TextEditingController();

  final MemberRepository _memberRepository = MemberRepository();

  @override
  Widget build(BuildContext context) => Form(
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
            hintText: 'Mot de passe, $minPasswordSize caractères minimum',
            focusNode: _passwordFocus,
            textfieldController: _password,
            validator: passwordValidator,
            obscureText: true,
            icon: Icons.lock),
        AppTextField(
            keyboardType: TextInputType.text,
            label: 'Confirmer le mot de passe',
            hintText: 'Mot de passe, $minPasswordSize caractères minimum',
            focusNode: _confirmPasswordFocus,
            textfieldController: _confirmPassword,
            validator: (value) {
              if (value == null || value.isEmpty || _password.text != value) {
                return 'Mot de passe incorrect';
              }
            },
            obscureText: true,
            icon: Icons.lock),
        AppButton(text: "S'inscrire", callback: _onSignin, color: mainColor)
      ]));

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _createUser(_email.text, _password.text);
    }
  }

  void _createUser(String email, String password) async {
    List<dynamic> response = await _memberRepository.signup(email, password);
    bool created = response[0];
    dynamic jsonResponse = response[1];

    if (created) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/login', (Route<dynamic> route) => false);
    }
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text(jsonResponse['confirm']), backgroundColor: mainColor));
  }
}
