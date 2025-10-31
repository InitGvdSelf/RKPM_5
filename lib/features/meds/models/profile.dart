class Profile {
  final String id;
  final String name;
  final int age;
  final String? avatarUrl;

  const Profile({
    required this.id,
    required this.name,
    required this.age,
    this.avatarUrl,
  });

  Profile copyWith({
    String? name,
    int? age,
    String? avatarUrl,
  }) {
    return Profile(
      id: id,
      name: name ?? this.name,
      age: age ?? this.age,
      avatarUrl: avatarUrl ?? this.avatarUrl,
    );
  }

  factory Profile.fromJson(Map<String, dynamic> json) => Profile(
    id: json['id'] as String,
    name: json['name'] as String,
    age: json['age'] as int,
    avatarUrl: json['avatarUrl'] as String?,
  );

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'age': age,
    'avatarUrl': avatarUrl,
  };
}