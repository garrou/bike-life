class Member {
  final String id;
  final String email;

  Member(this.id, this.email);

  Member.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        email = json['email'];

  Map<String, dynamic> toJson() => {'id': id, 'email': email};
}
