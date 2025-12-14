class AuthSessionDto {
  final String email;
  final String? name;

  AuthSessionDto({
    required this.email,
    this.name,
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'name': name,
  };

  factory AuthSessionDto.fromJson(Map<String, dynamic> json) => AuthSessionDto(
    email: json['email'] as String,
    name: json['name'] as String?,
  );
}

