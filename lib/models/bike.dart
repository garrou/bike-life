class Bike {
  final int id;
  final String name;
  final String image;
  final String description;
  final int nbKm;
  final String dateOfPurchase;

  Bike(this.id, this.name, this.image, this.description, this.nbKm,
      this.dateOfPurchase);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        image = json['image'],
        description = json['description'],
        nbKm = json['nb_km'],
        dateOfPurchase = json['date_of_purchase'];
}

List<Bike> createSeveralBikes(List record) {
  return record
      .map((bike) => Bike(bike['bike_id'], bike['name'], bike['image'],
          bike['description'], bike['nb_km'], bike['date_of_purchase']))
      .toList(growable: false);
}
