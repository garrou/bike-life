import 'package:bike_life/auth.dart';
import 'package:bike_life/constants.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class UpdateAuth extends StatelessWidget {
  const UpdateAuth({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    }));
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          AppTitle(text: 'Modifier mon profil'),
          BuildForm()
        ]);
  }
}

class BuildForm extends StatefulWidget {
  const BuildForm({Key? key}) : super(key: key);

  @override
  _SignupFormState createState() => _SignupFormState();
}

class _SignupFormState extends State<BuildForm> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Card(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(mainSize)),
        elevation: thirdSize,
        child: Padding(
            padding: const EdgeInsets.symmetric(vertical: mainSize),
            child: FormUpdateProfil(
                keyForm: _keyForm,
                email: _email,
                emailFocus: _emailFocus,
                password: _password,
                passwordFocus: _passwordFocus)));
  }
}

class FormUpdateProfil extends StatelessWidget {
  final GlobalKey<FormState> keyForm;
  final FocusNode emailFocus;
  final TextEditingController email;
  final FocusNode passwordFocus;
  final TextEditingController password;
  const FormUpdateProfil(
      {Key? key,
      required this.keyForm,
      required this.emailFocus,
      required this.email,
      required this.passwordFocus,
      required this.password})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
        key: keyForm,
        child: Column(children: <Widget>[
          AppTextfield(
              label: 'Email',
              hintText: 'Entrer un email valide',
              focusNode: emailFocus,
              textfieldController: email,
              validator: emailValidator,
              obscureText: false),
          AppTextfield(
              label: 'Mot de passe',
              hintText:
                  'Entrer un mot de passe de minimum $minPasswordSize caractères',
              focusNode: passwordFocus,
              textfieldController: password,
              validator: passwordValidator,
              obscureText: true),
          AppButton(text: 'Modifier', callback: _onUpdate)
        ]));
  }

  void _onUpdate() {
    if (keyForm.currentState!.validate()) {
      keyForm.currentState!.save();
      // TODO: Update profile
    }
  }
}
