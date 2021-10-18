import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/update_auth.dart';
import 'package:bike_life/views/styles/general.dart';
import 'package:bike_life/views/widgets/button.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class ProfilePage extends StatefulWidget {
  final Member member;
  const ProfilePage({Key? key, required this.member}) : super(key: key);

  @override
  _ProfilePageState createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
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

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const AppTitle(text: 'Profil', paddingTop: secondSize),
          const AppLinkToPage(
              text: 'Modifier mon profil', destination: UpdateAccountPage()),
          AppButton(
              text: 'Déconnexion', callback: _onDisconnect, color: mainColor)
        ]);
  }

  void _onDisconnect() {
    const storage = FlutterSecureStorage();
    storage.delete(key: 'jwt');
    Navigator.pushNamed(context, '/login');
  }
}
