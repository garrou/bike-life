import 'package:bike_life/routes/args/member_argument.dart';
import 'package:bike_life/views/member/profile.dart';
import 'package:flutter/material.dart';

class ProfilePageRoute extends StatelessWidget {
  static const routeName = '/profile';

  const ProfilePageRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MemberArgument;
    return ProfilePage(member: args.member);
  }
}
