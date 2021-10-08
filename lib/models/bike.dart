class Bike {
  final String name;
  final String image;
  final String description;

  Bike(this.name, this.image, this.description);

  Bike.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        description = json['description'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'image': image, 'description': description};
}

Bike createBike(record) {
  Map<String, String> attributes = {'title': '', 'email': '', 'password': ''};

  record.forEach((key, value) => {attributes[key] = value});

  return Bike(attributes['name'].toString(), attributes['password'].toString(),
      attributes['description'].toString());
}

List<Bike> createSeveralBikes(List record) {
  return record
      .map((bike) => Bike(bike['name'], bike['image'], bike['description']))
      .toList(growable: false);
}
