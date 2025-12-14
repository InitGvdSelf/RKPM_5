class UserDto {
  final String name;
  final int age;
  final String? avatarUrl;

  UserDto({
    required this.name,
    required this.age,
    this.avatarUrl,
  });

  Map<String, dynamic> toJson() => {
    'name': name,
    'age': age,
    'avatarUrl': avatarUrl,
  };

  factory UserDto.fromJson(Map<String, dynamic> json) => UserDto(
    name: json['name'] as String,
    age: json['age'] as int,
    avatarUrl: json['avatarUrl'] as String?,
  );
}

