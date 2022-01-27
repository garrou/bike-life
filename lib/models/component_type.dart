class ComponentType {
  final String name;
  final String value;

  ComponentType(this.name, this.value);

  ComponentType.fromJson(Map<String, dynamic> json)
      : name = json['name'],
        value = json['name'];
}

List<ComponentType> createComponentTypes(List<dynamic> records) {
  return records
      .map((json) => ComponentType.fromJson(json))
      .toList(growable: true);
}
