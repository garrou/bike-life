class Bike {
  final int id;
  final String name;
  final String image;
  final double nbKm;
  final String dateOfPurchase;

  Bike(this.id, this.name, this.image, this.nbKm, this.dateOfPurchase);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        nbKm = json['nb_km'],
        dateOfPurchase = json['date_of_purchase'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'nbKm': nbKm,
        'dateOfPurchase': dateOfPurchase
      };
}

List<Bike> createSeveralBikes(List record) {
  return record
      .map((bike) => Bike(bike['bike_id'], bike['name'], bike['image'],
          double.parse(bike['nb_km']), bike['date_of_purchase']))
      .toList(growable: false);
}
