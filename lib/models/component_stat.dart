class ComponentStat {
  final String label;
  final double value;

  ComponentStat.fromJson(Map<String, dynamic> json)
      : label = json['label'].toString(),
        value = double.parse(json['value']);

  ComponentStat(this.label, this.value);
}

List<ComponentStat> createComponentStats(List<dynamic> records) =>
    records.map((json) => ComponentStat.fromJson(json)).toList(growable: false);
