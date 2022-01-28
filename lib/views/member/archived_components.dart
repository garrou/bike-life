import 'dart:async';
import 'dart:convert';

import 'package:bike_life/models/component.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/styles/general.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/utils/guard_helper.dart';
import 'package:bike_life/utils/storage.dart';
import 'package:bike_life/views/auth/signin.dart';
import 'package:bike_life/views/member/component_details.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/title.dart';
import 'package:flutter/material.dart';
import 'package:flutter_guards/flutter_guards.dart';
import 'package:http/http.dart';

class ArchivedComponentsPage extends StatefulWidget {
  const ArchivedComponentsPage({Key? key}) : super(key: key);

  @override
  _ArchivedComponentsPageState createState() => _ArchivedComponentsPageState();
}

class _ArchivedComponentsPageState extends State<ArchivedComponentsPage> {
  final StreamController<bool> _authState = StreamController();
  final ComponentService _componentService = ComponentService();
  late Future<List<Component>> _components;

  @override
  void initState() {
    super.initState();
    GuardHelper.checkIfLogged(_authState);
    _components = _loadComponents();
  }

  @override
  Widget build(BuildContext context) => AuthGuard(
      authStream: _authState.stream,
      signedIn: _buildLayout(),
      signedOut: const SigninPage());

  Widget _buildLayout() => Column(children: [
        AppTitle(
            text: 'Composants archivés',
            paddingTop: mainSize,
            style: secondTextStyle),
        FutureBuilder<List<Component>>(
            future: _components,
            builder: (_, snapshot) {
              if (snapshot.hasError) {
                return Text('${snapshot.error}');
              } else if (snapshot.hasData) {
                return Expanded(
                    child: GridView.count(
                        controller: ScrollController(initialScrollOffset: 0),
                        padding: const EdgeInsets.fromLTRB(
                            thirdSize, thirdSize, thirdSize, thirdSize),
                        crossAxisCount: 3,
                        children: snapshot.data!
                            .map((item) => _buildCard(item))
                            .toList()));
              }
              return const AppLoading();
            })
      ]);

  Widget _buildCard(Component component) => GestureDetector(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => ComponentDetailPage(component: component))),
      child: MouseRegion(
          cursor: SystemMouseCursors.click,
          child: Card(
              child: Container(
                  child: Padding(
                      child: Text(component.type),
                      padding: const EdgeInsets.fromLTRB(
                          thirdSize, thirdSize, 0, 0)),
                  decoration: const BoxDecoration(
                      borderRadius:
                          BorderRadius.all(Radius.circular(thirdSize)),
                      image: DecorationImage(
                          fit: BoxFit.cover,
                          image: AssetImage('assets/green.png')))))));

  Future<List<Component>> _loadComponents() async {
    String memberId = await Storage.getMemberId();
    Response response =
        await _componentService.getArchivedMemberComponents(memberId);

    if (response.statusCode == httpCodeOk) {
      return createComponents(jsonDecode(response.body));
    } else {
      throw Exception('Impossible de récupérer les composants');
    }
  }
}
