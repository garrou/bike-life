class ComponentType {
  final String name;

  ComponentType(this.name);

  ComponentType.fromJson(Map<String, dynamic> json) : name = json['name'];
}

List<ComponentType> createComponentTypesFromList(List<dynamic> records) {
  return records
      .map((json) => ComponentType.fromJson(json))
      .toList(growable: false);
}
