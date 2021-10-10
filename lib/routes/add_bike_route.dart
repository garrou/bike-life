import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/views/member/add_bike.dart';
import 'package:flutter/material.dart';

class AddBikeRoute extends StatelessWidget {
  static const routeName = '/add-bike';

  const AddBikeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MemberArgument;
    return AddBikePage(member: args.member);
  }
}
