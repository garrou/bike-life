import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/profile/update_email.dart';
import 'package:bike_life/views/member/profile/update_password.dart';
import 'package:bike_life/widgets/buttons/button.dart';
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
          padding: const EdgeInsets.only(top: 30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
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
                      iconSize: 30,
                    )
                  ]),
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
                text: 'Déconnexion',
                color: Colors.red[900]!,
                callback: () => _onDisconnect(context),
                icon: const Icon(Icons.logout),
              )
            ],
          ),
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
          onTap: () => Navigator.push(
            context,
            animationRightLeft(destination),
          ),
        ),
      );
}
