import 'package:bike_life/routes/args/component_argument.dart';
import 'package:bike_life/views/member/component_details.dart';
import 'package:flutter/material.dart';

class ComponentDetailsRoute extends StatelessWidget {
  static const routeName = '/component';

  const ComponentDetailsRoute({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final args =
        ModalRoute.of(context)!.settings.arguments as ComponentArgument;
    return ComponentDetailPage(component: args.component);
  }
}
