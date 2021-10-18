import 'package:bike_life/constants.dart';
import 'package:bike_life/models/member.dart';
import 'package:bike_life/views/member/add_bike_form.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  final Member member;
  const AddBikePage({Key? key, required this.member}) : super(key: key);

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

  Widget narrowLayout() => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: wideLayout());

  Widget wideLayout() => SingleChildScrollView(
      child: Column(children: <Widget>[AddBikeForm(member: member)]));
}
