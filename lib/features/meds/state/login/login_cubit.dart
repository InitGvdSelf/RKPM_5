// lib/features/meds/state/login/login_cubit.dart
import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';

import 'login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthService auth;

  LoginCubit({required this.auth}) : super(LoginState.initial());

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    try {
      await auth.signIn(email: email, password: password);

      emit(state.copyWith(isSubmitting: false));
      return true;
    } catch (_) {
      emit(
        state.copyWith(
          isSubmitting: false,
          errorMessage: 'Не удалось войти. Проверьте почту и пароль.',
        ),
      );
      return false;
    }
  }
}