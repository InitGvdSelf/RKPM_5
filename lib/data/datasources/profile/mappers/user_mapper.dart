import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/data/datasources/profile/dto/user_dto.dart';

class UserMapper {
  static Profile toDomain(UserDto dto) {
    return Profile.fromJson(dto.toJson());
  }

  static UserDto toDto(Profile profile) {
    return UserDto.fromJson(profile.toJson());
  }
}

