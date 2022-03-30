import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/views/member/help/components_pictures.dart';
import 'package:bike_life/views/member/help/tips.dart';
import 'package:flutter/material.dart';

class HelpPage extends StatelessWidget {
  const HelpPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 2,
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: primaryColor,
            title: const Text('Aide et conseils'),
            bottom: const TabBar(
              indicatorColor: primaryColor,
              tabs: [
                Tab(icon: Icon(Icons.help)),
                Tab(icon: Icon(Icons.photo_library)),
              ],
            ),
          ),
          body: const TabBarView(
              children: [TipsPage(), ComponentsPicturesPage()]),
        ),
      );
}
