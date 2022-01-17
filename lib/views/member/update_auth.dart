import 'package:bike_life/constants.dart';
import 'package:bike_life/repositories/member_repository.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';

class UpdateAccountPage extends StatefulWidget {
  const UpdateAccountPage({Key? key}) : super(key: key);

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final MemberRepository _memberRepository = MemberRepository();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return narrowLayout();
        } else {
          return wideLayout();
        }
      }));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppTopLeftButton(
                title: 'Modifier mon profil',
                callback: () => Navigator.pushNamed(context, '/profile')),
            AppCard(child: buildForm(), elevation: secondSize)
          ]);

  Widget buildForm() => Form(
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
        AppButton(text: 'Modifier', callback: _onUpdate, color: mainColor)
      ]));

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      _updateAuth(_email.text, _password.text);
    }
  }

  void _updateAuth(String email, String password) async {
    int id = await Storage.getMemberId();
    // TODO: Update
  }
}
