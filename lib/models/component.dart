class Component {
  final String label;
  final String field;
  final int id;
  final String? brand;
  final int km;
  final int duration;

  Component(
      this.label, this.field, this.id, this.brand, this.km, this.duration);

  Component.fromJson(Map<String, dynamic> json, this.field, this.label)
      : id = json['${field}_id'],
        brand = json['${field}_brand'],
        km = json['${field}_km'],
        duration = json['${field}_duration'];

  Map<String, dynamic> toJson() => {
        'id': id,
        'brand': brand,
        'km': km,
        'duration': duration,
        'detail': field
      };
}
