import 'dart:async';

import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/update_auth.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/widgets/button.dart';
import 'package:bike_life/widgets/link_page.dart';
import 'package:bike_life/widgets/top_left_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  final StreamController<bool> _authState = StreamController();

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: LayoutBuilder(builder: (context, constraints) {
            if (constraints.maxWidth > maxSize) {
              return narrowLayout();
            } else {
              return wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        AppTopLeftButton(
            title: 'Profil',
            callback: () => Navigator.pushNamed(context, '/home')),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const <Widget>[
              Icon(Icons.edit, color: Colors.blue),
              AppLinkToPage(
                  padding: thirdSize,
                  child: Text('Modifier mon profil',
                      style:
                          TextStyle(fontSize: secondSize, color: Colors.blue)),
                  destination: UpdateAccountPage()),
            ]),
        AppButton(
            text: 'Déconnexion', callback: _onDisconnect, color: mainColor)
      ]);

  void _onDisconnect() {
    Storage.disconnect();
    Navigator.pushNamedAndRemoveUntil(
        context, '/login', (Route<dynamic> route) => false);
  }
}
