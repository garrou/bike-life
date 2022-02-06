class Bike {
  final String id;
  final String name;
  final double kmPerWeek;
  final int nbUsedPerWeek;
  final bool electric;
  final String type;
  final DateTime addedAt;

  Bike(this.id, this.name, this.kmPerWeek, this.nbUsedPerWeek, this.electric,
      this.type, this.addedAt);

  Bike.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        name = json['name'],
        kmPerWeek = double.parse(json['kmPerWeek']),
        nbUsedPerWeek = json['nbUsedPerWeek'],
        electric = json['electric'],
        type = json['type'],
        addedAt = DateTime.parse(json['addedAt']);

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'kmPerWeek': kmPerWeek,
        'nbUsedPerWeek': nbUsedPerWeek,
        'electric': electric,
        'type': type,
        'addedAt': addedAt.toString()
      };
}

List<Bike> createBikes(List records) {
  return records.map((json) => Bike.fromJson(json)).toList(growable: false);
}
