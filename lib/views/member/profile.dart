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
              return _narrowLayout();
            } else {
              return _wideLayout();
            }
          }),
          signedOut: const SigninPage()));

  Widget _narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout());

  Widget _wideLayout() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        AppTopLeftButton(
            title: 'Profil', callback: () => Navigator.of(context).pop()),
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
        AppButton(text: 'Aide', callback: () {}, color: deepGreen),
        AppButton(text: 'Déconnexion', callback: _onDisconnect, color: red)
      ]);

  void _onDisconnect() {
    Storage.disconnect();
    Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const SigninPage()),
        (Route<dynamic> route) => false);
  }
}
