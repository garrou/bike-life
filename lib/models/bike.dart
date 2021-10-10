class Bike {
  final int id;
  final String name;
  final String image;
  final String description;

  Bike(this.id, this.name, this.image, this.description);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['bike_id'],
        name = json['name'],
        image = json['image'],
        description = json['description'];
}

List<Bike> createSeveralBikes(List record) {
  return record
      .map((bike) => Bike(
          bike['bike_id'], bike['name'], bike['image'], bike['description']))
      .toList(growable: false);
}
