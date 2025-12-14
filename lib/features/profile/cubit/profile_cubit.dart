import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/profile_model.dart';
import 'package:rkpm_5/core/services/image_service.dart';
import 'package:rkpm_5/domain/usecases/profile/get_profile_usecase.dart';
import 'package:rkpm_5/domain/usecases/profile/update_profile_usecase.dart';
import 'package:rkpm_5/domain/usecases/auth/logout_usecase.dart';
import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final GetProfileUseCase getProfileUseCase;
  final UpdateProfileUseCase updateProfileUseCase;
  final LogoutUseCase logoutUseCase;
  final ImageService images;

  ProfileCubit({
    GetProfileUseCase? getProfileUseCase,
    UpdateProfileUseCase? updateProfileUseCase,
    LogoutUseCase? logoutUseCase,
    ImageService? images,
  })  : getProfileUseCase = getProfileUseCase ?? DI.getProfileUseCase,
        updateProfileUseCase = updateProfileUseCase ?? DI.updateProfileUseCase,
        logoutUseCase = logoutUseCase ?? DI.logoutUseCase,
        images = images ?? ImageService.instance,
        super(ProfileState.initial()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));

    final result = await getProfileUseCase();
    result.fold(
      (failure) => emit(
        state.copyWith(
          isLoading: false,
          error: failure.message,
        ),
      ),
      (profile) => emit(
        state.copyWith(
          isLoading: false,
          profile: profile ?? Profile(name: '', age: 0, avatarUrl: null),
        ),
      ),
    );
  }

  Future<void> saveProfile({
    required String name,
    required String ageText,
  }) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      final age = int.tryParse(ageText.trim()) ?? 0;
      final updated = Profile(
        name: name.trim(),
        age: age,
        avatarUrl: state.profile?.avatarUrl,
      );

      final result = await updateProfileUseCase(updated);
      result.fold(
        (failure) => emit(
          state.copyWith(
            isSaving: false,
            error: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            isSaving: false,
            profile: updated,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Не удалось сохранить профиль',
        ),
      );
    }
  }

  Future<void> changeAvatar({
    required String name,
    required String ageText,
  }) async {
    emit(state.copyWith(isSaving: true, error: null));

    try {
      final age = int.tryParse(ageText.trim()) ?? 0;
      final url = await images.nextAvatarImage();

      final updated = Profile(
        name: name.trim(),
        age: age,
        avatarUrl: url,
      );

      final result = await updateProfileUseCase(updated);
      result.fold(
        (failure) => emit(
          state.copyWith(
            isSaving: false,
            error: failure.message,
          ),
        ),
        (_) => emit(
          state.copyWith(
            isSaving: false,
            profile: updated,
          ),
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Не удалось обновить аватар',
        ),
      );
    }
  }

  Future<void> signOut() async {
    await logoutUseCase();
  }
}

