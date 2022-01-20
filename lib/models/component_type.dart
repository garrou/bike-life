class ComponentType {
  final String name;

  ComponentType(this.name);

  ComponentType.fromJson(Map<String, dynamic> json) : name = json['name'];
}

List<ComponentType> createSeveralComponentTypes(List<dynamic> record) {
  return record
      .map((json) => ComponentType.fromJson(json))
      .toList(growable: false);
}
