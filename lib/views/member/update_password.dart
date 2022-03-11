import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';

class UpdatePassword extends StatefulWidget {
  const UpdatePassword({Key? key}) : super(key: key);

  @override
  State<UpdatePassword> createState() => _UpdatePasswordState();
}

class _UpdatePasswordState extends State<UpdatePassword> {
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
                  validator: (value) {
                    if (_password.text != value || value!.isEmpty) {
                      return 'Mot de passe incorrect';
                    }
                    return '';
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
