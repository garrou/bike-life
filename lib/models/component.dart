class Component {
  final String label;
  final int id;
  final String? brand;
  final int km;
  final int duration;

  Component(this.label, this.id, this.brand, this.km, this.duration);

  Component.fromJson(Map<String, dynamic> json, String detail, this.label)
      : id = json['${detail}_id'],
        brand = json['${detail}_brand'],
        km = json['${detail}_km'],
        duration = json['${detail}_duration'];
}
