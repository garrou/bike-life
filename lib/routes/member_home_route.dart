import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/views/member/member_home.dart';
import 'package:flutter/material.dart';

class MemberHomeRoute extends StatelessWidget {
  static const routeName = '/member-home';

  const MemberHomeRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MemberArgument;
    return MemberHomePage(member: args.member);
  }
}
