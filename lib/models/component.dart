class Component {
  final int id;
  final int bikeId;
  final double km;
  final String? brand;
  final String? dateOfPurchase;
  final double duration;
  final String? image;
  final String type;

  Component(this.id, this.bikeId, this.km, this.brand, this.dateOfPurchase,
      this.duration, this.image, this.type);

  Component.fromJson(Map<String, dynamic> json)
      : id = json['component_id'],
        bikeId = json['bike_id'],
        km = double.parse(json['nb_km']),
        duration = double.parse(json['duration']),
        brand = json['brand'],
        dateOfPurchase = json['date_of_purchase'],
        image = json['image'],
        type = json['component_type'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'bikeId': bikeId,
        'km': km,
        'brand': brand,
        'dateOfPurchase': dateOfPurchase,
        'duration': duration,
        'image': image,
        'type': type
      };
}

List<Component> createSeveralComponents(List<dynamic> records) {
  return records
      .map((json) => Component.fromJson(json))
      .toList(growable: false);
}
