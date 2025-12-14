import 'package:rkpm_5/domain/repositories/profile_repository.dart';
import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/core/errors/failure.dart';
import 'package:rkpm_5/core/utils/either.dart';
import 'package:rkpm_5/data/datasources/profile/profile_local_data_source.dart';
import 'package:rkpm_5/data/datasources/profile/mappers/user_mapper.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  final ProfileLocalDataSource dataSource;

  ProfileRepositoryImpl(this.dataSource);

  @override
  Future<Either<Failure, Profile?>> getProfile() async {
    try {
      final dto = await dataSource.getProfile();
      if (dto == null) {
        return Either.right(null);
      }
      return Either.right(UserMapper.toDomain(dto));
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> updateProfile(Profile profile) async {
    try {
      final dto = UserMapper.toDto(profile);
      await dataSource.saveProfile(dto);
      return Either.right(null);
    } catch (e) {
      return Either.left(CacheFailure(e.toString()));
    }
  }
}

