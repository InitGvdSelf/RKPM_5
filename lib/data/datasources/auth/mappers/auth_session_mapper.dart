import 'package:rkpm_5/core/models/user_model.dart';
import 'package:rkpm_5/data/datasources/auth/dto/auth_session_dto.dart';

class AuthSessionMapper {
  static UserAccount toDomain(AuthSessionDto dto) {
    return UserAccount(
      email: dto.email,
      name: dto.name,
    );
  }

  static AuthSessionDto toDto(UserAccount user) {
    return AuthSessionDto(
      email: user.email,
      name: user.name,
    );
  }
}

