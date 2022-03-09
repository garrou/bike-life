import 'package:bike_life/styles/animations.dart';
import 'package:bike_life/providers/theme_provider.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/update_email.dart';
import 'package:bike_life/views/member/update_password.dart';
import 'package:bike_life/widgets/buttons/top_right_button.dart';
import 'package:bike_life/widgets/link_page.dart';
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
        return Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            AppTopRightButton(
                onPressed: () => _onDisconnect(context),
                icon: const Icon(
                  Icons.logout,
                ),
                color: red,
                padding: secondSize),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
              Text('Thème', style: mainTextStyle),
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
            AppLinkToPage(
              padding: 5,
              child: Text("Changer votre email", style: linkStyle),
              destination: const UpdateEmail(),
            ),
            AppLinkToPage(
              padding: 5,
              child: Text("Changer votre mot de passe", style: linkStyle),
              destination: const UpdatePassword(),
            ),
          ],
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
