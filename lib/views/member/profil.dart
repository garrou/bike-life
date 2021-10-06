import 'package:bike_life/constants.dart';
import 'package:bike_life/views/member/update_auth.dart';
import 'package:bike_life/views/widgets/link_page.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class ProfilPage extends StatelessWidget {
  const ProfilPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      if (constraints.maxWidth > maxSize) {
        return narrowLayout();
      } else {
        return wideLayout();
      }
    });
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }

  Widget wideLayout() {
    return Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: const <Widget>[
          AppTitle(text: 'Profil'),
          AppLinkToPage(text: 'Modifier mon profil', destination: UpdateAuth())
        ]);
  }

  void _onDisconnect() {
    // TODO: Disconnect
  }
}
