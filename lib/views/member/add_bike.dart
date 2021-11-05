import 'package:bike_life/constants.dart';
import 'package:bike_life/views/forms/add_bike_form.dart';
import 'package:flutter/material.dart';

class AddBikePage extends StatelessWidget {
  const AddBikePage({Key? key}) : super(key: key);

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

  Widget wideLayout() => SingleChildScrollView(
      child: Column(children: const <Widget>[AddBikeForm()]));
}
