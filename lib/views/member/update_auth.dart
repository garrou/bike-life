import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/routes/profile_page_route.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/card.dart';
import 'package:bike_life/views/widgets/textfield.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';

class UpdateAccountPage extends StatefulWidget {
  final Member member;
  const UpdateAccountPage({Key? key, required this.member}) : super(key: key);

  @override
  _UpdateAccountPageState createState() => _UpdateAccountPageState();
}

class _UpdateAccountPageState extends State<UpdateAccountPage> {
  final _keyForm = GlobalKey<FormState>();

  final _emailFocus = FocusNode();
  final _email = TextEditingController();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

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

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppTopLeftButton(callback: _onClickBackButton),
            const AppTitle(text: 'Modifier mon profil', paddingTop: secondSize),
            AppCard(child: buildForm(), elevation: secondSize)
          ]);

  Widget buildForm() => Form(
      key: _keyForm,
      child: Column(children: <Widget>[
        AppTextField(
            label: 'Email',
            hintText: 'Entrer un email valide',
            focusNode: _emailFocus,
            textfieldController: _email,
            validator: emailValidator,
            obscureText: false,
            icon: Icons.alternate_email,
            maxLines: 1),
        AppTextField(
            label: 'Mot de passe',
            hintText:
                'Entrer un mot de passe de minimum $minPasswordSize caractères',
            focusNode: _passwordFocus,
            textfieldController: _password,
            validator: passwordValidator,
            obscureText: true,
            icon: Icons.lock,
            maxLines: 1),
        AppButton(text: 'Modifier', callback: _onUpdate, color: mainColor)
      ]));

  void _onUpdate() {
    if (_keyForm.currentState!.validate()) {
      _keyForm.currentState!.save();
      // TODO: Update profile
    }
  }

  void _onClickBackButton() {
    Navigator.pushNamed(context, ProfilePageRoute.routeName,
        arguments: MemberArgument(widget.member));
  }
}
