import 'package:bike_life/utils/redirects.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/home/home.dart';
import 'package:bike_life/views/member/help/tips.dart';
import 'package:bike_life/views/member/profile/profile.dart';
import 'package:bike_life/views/member/statistics/statistics.dart';
import 'package:flutter/material.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: [
            DrawerHeader(child: Container()),
            ListTile(
              leading: const Icon(Icons.directions_bike_outlined),
              title: const Text('Accueil'),
              onTap: () => push(context, const HomePage()),
            ),
            ListTile(
              leading: const Icon(Icons.bar_chart_outlined),
              title: const Text('Statistiques'),
              onTap: () => push(context, const StatisticsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.help_outlined),
              title: const Text('Conseils'),
              onTap: () => push(context, const TipsPage()),
            ),
            ListTile(
              leading: const Icon(Icons.person_outlined),
              title: const Text('Profil'),
              onTap: () => push(context, const ProfilePage()),
            ),
            ListTile(
              leading: const Icon(Icons.logout_outlined),
              title: const Text('Déconnexion'),
              onTap: () {
                Storage.disconnect();
                pushAndRemove(context, const SigninPage());
              },
            ),
          ],
        ),
      );
}
