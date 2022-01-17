import 'package:bike_life/constants.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/member/update_auth.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/widgets/top_left_button.dart';
import 'package:flutter/material.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({Key? key}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Widget wideLayout() =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        AppTopLeftButton(
            title: 'Profil',
            callback: () => Navigator.pushNamed(context, '/home')),
        const AppLinkToPage(
            padding: mainSize,
            child: Text('Modifier mon profil',
                style: TextStyle(
                    decoration: TextDecoration.underline,
                    color: Colors.blue,
                    fontSize: secondSize)),
            destination: UpdateAccountPage()),
        AppButton(
            text: 'Déconnexion', callback: _onDisconnect, color: mainColor)
      ]);

  void _onDisconnect() {
    Storage.disconnect();
    Navigator.pushNamed(context, '/login');
  }
}
