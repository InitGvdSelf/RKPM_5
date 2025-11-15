// lib/features/meds/state/register_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';

import 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final AuthService auth;

  RegisterCubit({required this.auth}) : super(RegisterState.initial());

  Future<bool> register({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await auth.signUp(
        name: name,
        email: email,
        password: password,
      );

      emit(state.copyWith(isSubmitting: false));
      return true;
    } catch (e) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Не удалось создать аккаунт. Попробуйте ещё раз.',
        ),
      );
      return false;
    }
  }
}