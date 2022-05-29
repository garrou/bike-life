import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/member_service.dart';
import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/utils/validator.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/profile/update_email.dart';
import 'package:bike_life/views/member/profile/update_password.dart';
import 'package:bike_life/widgets/buttons/button.dart';
import 'package:bike_life/widgets/buttons/top_right_button.dart';
import 'package:bike_life/widgets/snackbar.dart';
import 'package:bike_life/widgets/textfield.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() =>
      Consumer<ThemeModel>(builder: (context, ThemeModel themeNotifier, child) {
        return Padding(
          padding: const EdgeInsets.only(top: firstSize),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              AppTopRightButton(
                paddingTop: 10,
                color: Colors.red[900]!,
                onPressed: () => _onDisconnect(context),
                icon: const Icon(Icons.logout),
              ),
              Row(
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
                    iconSize: firstSize,
                  )
                ],
              ),
              const AppClickCard(
                icon: Icon(Icons.alternate_email),
                text: 'Changer votre email',
                destination: UpdateEmailPage(),
              ),
              const AppClickCard(
                icon: Icon(Icons.password),
                text: 'Changer votre mot de passe',
                destination: UpdatePasswordPage(),
              ),
              AppButton(
                height: buttonHeight * 1.2,
                width: buttonWidth * 1.4,
                text: 'Supprimer mon compte',
                color: Colors.red[900]!,
                callback: () => _onDeleteAccount(context),
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      });

  void _onDisconnect(BuildContext context) {
    Storage.disconnect();
    pushAndRemove(context, const SigninPage());
  }

  void _onDeleteAccount(BuildContext context) async {
    final _key = GlobalKey<FormState>();

    final _passwordFocus = FocusNode();
    final _password = TextEditingController();

    final _memberService = MemberService();

    void _deleteAccount() async {
      HttpResponse response =
          await _memberService.authMember(_password.text.trim());

      if (response.success()) {
        response = await _memberService.deleteAccount();

        if (response.success()) {
          showSuccessSnackBar(context, response.message());
          _onDisconnect(context);
        } else {
          showErrorSnackBar(context, response.message());
        }
      } else {
        showErrorSnackBar(context, response.message());
      }
    }

    void _onDelete() {
      if (_key.currentState!.validate()) {
        _key.currentState!.save();
        _deleteAccount();
      }
    }

    return await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Suppression de votre compte', style: thirdTextStyle),
            contentPadding: const EdgeInsets.all(firstSize),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(firstSize),
            ),
            actions: <Widget>[
              AppButton(
                text: 'Supprimer',
                color: Colors.red[900]!,
                callback: _onDelete,
                icon: const Icon(Icons.delete),
              ),
            ],
            content: Builder(builder: (context) {
              double width = MediaQuery.of(context).size.width;
              double height = MediaQuery.of(context).size.height;

              return SizedBox(
                width: width > maxWidth ? width / 3 : width,
                height: height / 3,
                child: Form(
                  key: _key,
                  child: AppTextField(
                    keyboardType: TextInputType.text,
                    label: 'Mot de passe',
                    focusNode: _passwordFocus,
                    textfieldController: _password,
                    validator: fieldValidator,
                    icon: Icons.password,
                    obscureText: true,
                  ),
                ),
              );
            }),
          );
        });
  }
}

class AppClickCard extends StatelessWidget {
  final String text;
  final Widget destination;
  final Icon icon;
  const AppClickCard(
      {Key? key,
      required this.text,
      required this.destination,
      required this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) => Card(
        elevation: 5,
        child: InkWell(
          child: ListTile(
            leading: icon,
            title: Text(
              text,
              style: secondTextStyle,
            ),
          ),
          onTap: () => push(context, destination),
        ),
      );
}
