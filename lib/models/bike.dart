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
        nbKm = double.parse(json['nbKm']),
        dateOfPurchase = json['dateOfPurchase'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'nbKm': nbKm,
        'dateOfPurchase': dateOfPurchase
      };
}

List<Bike> createBikesFromList(List records) {
  return records.map((json) => Bike.fromJson(json)).toList(growable: false);
}
