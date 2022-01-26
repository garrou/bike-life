import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component_type.dart';
import 'package:bike_life/models/tip.dart';
import 'package:bike_life/services/component_types_service.dart';
import 'package:bike_life/services/tip_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/widgets/tip_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class TipsPage extends StatefulWidget {
  const TipsPage({Key? key}) : super(key: key);

  @override
  _TipsPageState createState() => _TipsPageState();
}

class _TipsPageState extends State<TipsPage> {
  final StreamController<bool> _authState = StreamController();
  final TipService _tipService = TipService();
  final ComponentTypesService _componentTypesService = ComponentTypesService();
  List<ComponentType> _componentTypes = [];
  List<Tip> _tips = [];
  String? _value = '%';

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _load();
  }

  void _load() async {
    Response responseTips = await _tipService.getAll();
    Response responseComponents = await _componentTypesService.getTypes();

    if (responseTips.statusCode == httpCodeOk &&
        responseComponents.statusCode == httpCodeOk) {
      setState(() {
        _tips = createTipsFromList(jsonDecode(responseTips.body));
        _componentTypes =
            createComponentTypesFromList(jsonDecode(responseComponents.body));
        _componentTypes.add(ComponentType('Tous', '%'));
        _componentTypes = _componentTypes.reversed.toList();
      });
    }
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: Scaffold(body: LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxSize) {
          return _narrowLayout(context);
        } else {
          return _wideLayout(context);
        }
      })),
      signedOut: const SigninPage());

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: const EdgeInsets.symmetric(horizontal: maxPadding),
      child: _wideLayout(context));

  Widget _wideLayout(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.center, children: <Widget>[
        Padding(
            padding: const EdgeInsets.only(top: secondSize),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  DropdownButton(
                      value: _value,
                      onChanged: _onSearch,
                      items: _componentTypes
                          .map<DropdownMenuItem<String>>(
                              (ComponentType componentType) => DropdownMenuItem(
                                  child: Text(componentType.name,
                                      style: thirdTextStyle),
                                  value: componentType.value))
                          .toList())
                ])),
        const Divider(color: deepGreen),
        for (Tip tip in _tips) AppTipCard(tip: tip)
      ]);

  void _onSearch(String? value) async {
    Response response = await _tipService.getByType(value!);
    setState(() {
      _value = value;
      _tips = createTipsFromList(jsonDecode(response.body));
    });
  }
}
