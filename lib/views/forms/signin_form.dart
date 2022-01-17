import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:flutter/material.dart';

class SigninForm extends StatefulWidget {
  const SigninForm({Key? key}) : super(key: key);

  @override
  _SigninFormState createState() => _SigninFormState();
}

class _SigninFormState extends State<SigninForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

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
            hintText: 'Entrer votre mot de passe',
            focusNode: _passwordFocus,
            textfieldController: _password,
            validator: passwordValidator,
            obscureText: true,
            icon: Icons.lock),
        AppButton(text: 'Connexion', callback: _onSignin, color: mainColor)
      ]));

  void _onSignin() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _authUser(_email.text, _password.text);
    }
  }

  void _authUser(String email, String password) async {
    List<dynamic> response = await _memberRepository.login(email, password);

    if (response[0]) {
      Navigator.pushNamedAndRemoveUntil(
          context, '/home', (Route<dynamic> route) => false);
    } else {
      _password.text = '';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text(response[1]['confirm']),
          backgroundColor: Theme.of(context).errorColor));
    }
  }
}
