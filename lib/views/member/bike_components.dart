import 'package:bike_life/models/bike.dart';
import 'package:bike_life/models/component.dart';
import 'package:bike_life/models/http_response.dart';
import 'package:bike_life/services/component_service.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:bike_life/widgets/component_card.dart';
import 'package:bike_life/widgets/loading.dart';
import 'package:bike_life/widgets/buttons/top_left_button.dart';
import 'package:flutter/material.dart';

class BikeComponentsPage extends StatefulWidget {
  final Bike bike;
  const BikeComponentsPage({Key? key, required this.bike}) : super(key: key);

  @override
  _BikeComponentsPageState createState() => _BikeComponentsPageState();
}

class _BikeComponentsPageState extends State<BikeComponentsPage> {
  late Future<List<Component>> _components;

  @override
  void initState() {
    super.initState();
    _components = _loadComponents();
  }

  Future<List<Component>> _loadComponents() async {
    final HttpResponse response =
        await ComponentService().getBikeComponents(widget.bike.id);

    if (response.success()) {
      return createComponents(response.body());
    } else {
      throw Exception('Impossible de récupérer les données');
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        body: LayoutBuilder(builder: (context, constraints) {
          if (constraints.maxWidth > maxWidth) {
            return _narrowLayout(context);
          } else {
            return _wideLayout();
          }
        }),
      );

  Widget _narrowLayout(BuildContext context) => Padding(
      padding: EdgeInsets.symmetric(
          horizontal: MediaQuery.of(context).size.width / 8),
      child: _wideLayout());

  Widget _wideLayout() => ListView(children: [
        AppTopLeftButton(title: 'Composants', callback: _back),
        _buildList()
      ]);

  FutureBuilder _buildList() => FutureBuilder<List<Component>>(
      future: _components,
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Text('${snapshot.error}');
        } else if (snapshot.hasData) {
          return ListView.builder(
              physics: const ScrollPhysics(),
              itemCount: snapshot.data!.length,
              shrinkWrap: true,
              itemBuilder: (_, index) =>
                  AppComponentCard(component: snapshot.data![index]));
        }
        return const AppLoading();
      });

  void _back() => Navigator.of(context).pop();
}
