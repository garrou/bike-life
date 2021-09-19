class Bike {
  final String name;
  final String image;
  final String details;

  Bike(this.name, this.image, this.details);

  Bike.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        image = json['image'],
        details = json['details'];

  Map<String, dynamic> toJson() =>
      {'name': name, 'image': image, 'details': details};
}

Bike createBike(record) {
  Map<String, String> attributes = {'title': '', 'email': '', 'password': ''};

  record.forEach((key, value) => {attributes[key] = value});

  return Bike(attributes['name'].toString(), attributes['password'].toString(),
      attributes['details'].toString());
}

List<Bike> createSeveralBikes(List record) {
  return record
      .map((bike) => Bike(bike["name"], bike["image"], bike["details"]))
      .toList(growable: false);
}
