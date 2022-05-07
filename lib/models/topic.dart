class Topic {
  final String name;

  Topic(this.name);

  Topic.fromJson(Map<String, dynamic> json) : name = json['name'];
}

List<Topic> createTopics(List<dynamic> records) =>
    records.map((json) => Topic.fromJson(json)).toList(growable: false);
