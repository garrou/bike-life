class Component {
  final String id;
  final double duration;
  final String type;

  Component(this.id, this.duration, this.type);

  Component.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        duration = double.parse(json['duration']),
        type = json['type'];

  Map<String, dynamic> toJson() =>
      {'id': id, 'duration': duration, 'type': type};
}

List<Component> createComponents(List<dynamic> records) {
  return records
      .map((json) => Component.fromJson(json))
      .toList(growable: false);
}
