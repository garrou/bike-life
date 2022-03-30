import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:photo_view/photo_view.dart';

class ComponentsPicturesPage extends StatefulWidget {
  const ComponentsPicturesPage({Key? key}) : super(key: key);

  @override
  State<ComponentsPicturesPage> createState() => _ComponentsPicturesPageState();
}

class _ComponentsPicturesPageState extends State<ComponentsPicturesPage> {
  late List<Picture> _pictures;

  @override
  void initState() {
    super.initState();
    _pictures = [
      Picture('Vélo', 'assets/bike_details.jpg'),
      Picture('Pneus', 'assets/pneus.jpg'),
      Picture('Batterie', 'assets/batterie.jpg'),
      Picture('Cassette', 'assets/cassette.jpg'),
      Picture('Chaîne', 'assets/chaine.jpg'),
      Picture('Dérailleur avant', 'assets/derailleur_avant.jpg'),
      Picture('Dérailleur arrière', 'assets/derailleur_arriere.jpg'),
      Picture('Frein à patins avant', 'assets/frein_patin_avant.jpg'),
      Picture('Frein à patin arrière', 'assets/frein_patin_arriere.jpg')
    ];
  }

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > maxWidth) {
          return _narrowLayout(context, constraints);
        } else {
          return _wideLayout(context, constraints);
        }
      });

  Widget _narrowLayout(
          BuildContext context, BoxConstraints constraints) =>
      Padding(
          padding: EdgeInsets.symmetric(
              horizontal: MediaQuery.of(context).size.width / 12),
          child: _wideLayout(context, constraints));

  Widget _wideLayout(BuildContext context, BoxConstraints constraints) =>
      ScrollConfiguration(
        behavior: const ScrollBehavior().copyWith(overscroll: false),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 5,
            mainAxisSpacing: 5,
            crossAxisCount: 3,
          ),
          itemCount: _pictures.length,
          itemBuilder: (_, int index) {
            return _buildImageContainer(
                _pictures[index].name, _pictures[index].path);
          },
        ),
      );

  Widget _buildImageContainer(String title, String image) => Column(
        children: <Widget>[
          Padding(
            child: Text(title, style: secondTextStyle),
            padding: const EdgeInsets.all(5.0),
          ),
          Padding(
            child: Image.asset(
              image,
              fit: BoxFit.contain,
            ),
            padding: const EdgeInsets.all(5.0),
          ),
        ],
      );
}

class Picture {
  final String name;
  final String path;

  Picture(this.name, this.path);
}
