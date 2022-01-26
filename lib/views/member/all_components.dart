import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class AllComponentsPage extends StatefulWidget {
  const AllComponentsPage({Key? key}) : super(key: key);

  @override
  _AllComponentsPageState createState() => _AllComponentsPageState();
}

class _AllComponentsPageState extends State<AllComponentsPage> {
  final StreamController<bool> _authState = StreamController();
  final ComponentService _componentService = ComponentService();
  List<Component> _components = [];

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _load();
  }

  void _load() async {
    String memberId = await Storage.getMemberId();
    Response response = await _componentService.getMemberComponents(memberId);

    if (response.statusCode == httpCodeOk) {
      setState(() {
        _components = createComponentsFromList(jsonDecode(response.body));
      });
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      body: AuthGuard(
          authStream: _authState.stream,
          signedIn: _layout(),
          signedOut: const SigninPage()));

  Widget _layout() => GridView.count(
      controller: ScrollController(initialScrollOffset: 0),
      mainAxisSpacing: 10.0,
      crossAxisSpacing: 10.0,
      crossAxisCount: 3,
      // TODO: Dynamic display column
      children: _components
          .map((item) => Card(
              child: Container(
                  // TODO: display icon if archived
                  child: Padding(
                      child: Text(item.type),
                      padding: const EdgeInsets.fromLTRB(10, 10, 0, 0)),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(thirdSize)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/green.png'))))))
          .toList());
}
