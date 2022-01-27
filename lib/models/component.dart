class Component {
  final String id;
  final String bikeId;
  final double km;
  final String? brand;
  final String dateOfPurchase;
  final double duration;
  final String? image;
  final String type;
  final bool archived;

  Component(this.id, this.bikeId, this.km, this.brand, this.dateOfPurchase,
      this.duration, this.image, this.type, this.archived);

  Component.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        bikeId = json['bikeId'],
        km = double.parse(json['km']),
        duration = double.parse(json['duration']),
        brand = json['brand'],
        dateOfPurchase = json['dateOfPurchase'],
        image = json['image'],
        type = json['type'],
        archived = json['archived'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'bikeId': bikeId,
        'km': km,
        'brand': brand,
        'dateOfPurchase': dateOfPurchase,
        'duration': duration,
        'image': image,
        'type': type,
        'archived': archived
      };
}

List<Component> createComponentsFromList(List<dynamic> records) {
  return records
      .map((json) => Component.fromJson(json))
      .toList(growable: false);
}
