import 'package:bike_life/styles/styles.dart';
import 'package:bike_life/utils/constants.dart';
import 'package:flutter/material.dart';

class ComponentsPicturesPage extends StatelessWidget {
  const ComponentsPicturesPage({Key? key}) : super(key: key);

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
      GridView.count(
        crossAxisCount: constraints.maxWidth > maxWidth + 400
            ? 3
            : constraints.maxWidth > maxWidth
                ? 2
                : 1,
        children: <Widget>[
          _buildImageContainer('Vélo', 'assets/bike_details.jpg'),
          _buildImageContainer('Pneus', 'assets/pneus.jpg'),
          _buildImageContainer('Batterie', 'assets/batterie.jpg'),
          _buildImageContainer('Cassette', 'assets/cassette.jpg'),
          _buildImageContainer('Chaîne', 'assets/chaine.jpg'),
          _buildImageContainer(
              'Dérailleur avant', 'assets/derailleur_avant.jpg'),
          _buildImageContainer(
              'Dérailleur arrière', 'assets/derailleur_arriere.jpg'),
          _buildImageContainer(
              'Frein à patins avant', 'assets/frein_patin_avant.jpg'),
          _buildImageContainer(
              'Frein à patin arrière', 'assets/frein_patin_arriere.jpg')
        ],
      );

  Widget _buildImageContainer(String title, String image) =>
      Column(children: <Widget>[
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
      ]);
}
