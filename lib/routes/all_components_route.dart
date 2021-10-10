import 'package:bike_life/routes/member_argument.dart';
import 'package:bike_life/views/member/all_components.dart';
import 'package:flutter/material.dart';

class AllComponentsRoute extends StatelessWidget {
  static const routeName = '/all-components';

  const AllComponentsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments as MemberArgument;
    return AllComponentsPage(member: args.member);
  }
}
