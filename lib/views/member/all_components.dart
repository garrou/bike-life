import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/widgets/back_button.dart';
import 'package:bike_life/views/widgets/title.dart';
import 'package:flutter/material.dart';

class AllComponentsPage extends StatefulWidget {
  final Member member;
  const AllComponentsPage({Key? key, required this.member}) : super(key: key);

  @override
  _AllComponentsPageState createState() => _AllComponentsPageState();
}

class _AllComponentsPageState extends State<AllComponentsPage> {
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

  Widget wideLayout() {
    return Column(children: <Widget>[
      AppBackButton(callback: () => Navigator.pop(context)),
      const AppTitle(text: 'Tous les composants', paddingTop: 0.0)
      // TODO; Add all components
    ]);
  }

  Widget narrowLayout() {
    return Padding(
        padding: const EdgeInsets.symmetric(horizontal: maxPadding),
        child: wideLayout());
  }
}
