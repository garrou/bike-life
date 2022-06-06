import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class UpdatePasswordPage extends StatefulWidget {
  const UpdatePasswordPage({Key? key}) : super(key: key);

  @override
  State<UpdatePasswordPage> createState() => _UpdatePasswordPageState();
}

class _UpdatePasswordPageState extends State<UpdatePasswordPage> {
  final _keyForm = GlobalKey<FormState>();

  final _passwordFocus = FocusNode();
  final _password = TextEditingController();

  final _confirmPassFocus = FocusNode();
  final _confirmPass = TextEditingController();

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

  Widget _wideLayout() => Scaffold(
        body: Form(
          key: _keyForm,
          child: Column(
            children: <Widget>[
              AppTopLeftButton(
                title: "Changer le mot de passe",
                callback: () => Navigator.pop(context),
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: 'Mot de passe ($minPasswordSize caractères minimum)',
                focusNode: _passwordFocus,
                textfieldController: _password,
                validator: (value) =>
                    passwordValidator(value, minPasswordSize, maxPasswordSize),
                obscureText: true,
                icon: Icons.password_outlined,
              ),
              AppTextField(
                keyboardType: TextInputType.text,
                label: 'Confirmer le mot de passe',
                focusNode: _confirmPassFocus,
                textfieldController: _confirmPass,
                // ignore: body_might_complete_normally_nullable
                validator: (value) {
                  if (_password.text != value || value!.isEmpty) {
                    return 'Mot de passe incorrect';
                  }
                },
                obscureText: true,
                icon: Icons.password_outlined,
              ),
              AppButton(
                text: "Modifier",
                callback: () => _onUpdate(context),
                icon: const Icon(
                  Icons.save_outlined,
                ),
              )
            ],
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
    final HttpResponse response =
        await MemberService().updatePassword(_password.text.trim());

    if (response.success()) {
      pushAndRemove(context, const MemberHomePage(initialIndex: 3));
      showSuccessSnackBar(context, response.message());
    } else {
      showErrorSnackBar(context, response.message());
    }
  }
}
