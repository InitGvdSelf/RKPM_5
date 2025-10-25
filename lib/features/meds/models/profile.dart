import 'dart:convert';

class Profile {
  String name;
  int age;
  String? avatarUrl;

  Profile({required this.name, required this.age, this.avatarUrl});

  Map<String, dynamic> toJson() => {'name': name, 'age': age, 'avatarUrl': avatarUrl};

  factory Profile.fromJson(Map<String, dynamic> j) =>
      Profile(name: j['name'] ?? '', age: (j['age'] ?? 0) as int, avatarUrl: j['avatarUrl'] as String?);

  String toJsonString() => jsonEncode(toJson());
  static Profile fromJsonString(String s) => Profile.fromJson(jsonDecode(s) as Map<String, dynamic>);
}