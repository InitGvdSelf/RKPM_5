import 'package:bloc/bloc.dart';

import 'package:rkpm_5/features/meds/models/profile.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';
import 'package:rkpm_5/features/meds/domain/image_service.dart';
import 'package:rkpm_5/features/meds/domain/profile_storage.dart';

import 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final AuthService auth;
  final ImageService images;

  ProfileCubit({
    required this.auth,
    required this.images,
  }) : super(ProfileState.initial()) {
    load();
  }

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final stored = await ProfileStorage.load();
      final profile = stored ?? Profile(name: '', age: 0, avatarUrl: null);

      emit(
        state.copyWith(
          isLoading: false,
          profile: profile,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Не удалось загрузить профиль',
        ),
      );
    }
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

      await ProfileStorage.save(updated);
      emit(
        state.copyWith(
          isSaving: false,
          profile: updated,
        ),
      );
    } catch (_) {
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

      await ProfileStorage.save(updated);
      emit(
        state.copyWith(
          isSaving: false,
          profile: updated,
        ),
      );
    } catch (_) {
      emit(
        state.copyWith(
          isSaving: false,
          error: 'Не удалось обновить аватар',
        ),
      );
    }
  }

  Future<void> signOut() async {
    await auth.signOut();
  }
}