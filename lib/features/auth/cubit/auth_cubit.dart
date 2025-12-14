import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/domain/usecases/auth/login_usecase.dart';
import 'package:rkpm_5/domain/usecases/auth/register_usecase.dart';
import 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final LoginUseCase loginUseCase;
  final RegisterUseCase registerUseCase;

  AuthCubit({
    LoginUseCase? loginUseCase,
    RegisterUseCase? registerUseCase,
  })  : loginUseCase = loginUseCase ?? DI.loginUseCase,
        registerUseCase = registerUseCase ?? DI.registerUseCase,
        super(AuthState.initial());

  Future<bool> signIn({
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await loginUseCase(email: email, password: password);
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }

  Future<bool> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    emit(state.copyWith(isSubmitting: true, errorMessage: null));

    final result = await registerUseCase(
      name: name,
      email: email,
      password: password,
    );
    return result.fold(
      (failure) {
        emit(
          state.copyWith(
            isSubmitting: false,
            errorMessage: failure.message,
          ),
        );
        return false;
      },
      (_) {
        emit(state.copyWith(isSubmitting: false));
        return true;
      },
    );
  }
}

