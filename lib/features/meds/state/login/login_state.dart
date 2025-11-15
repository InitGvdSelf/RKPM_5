// lib/features/meds/state/login_state.dart
import 'package:equatable/equatable.dart';

class LoginState extends Equatable {
  final bool isSubmitting;
  final String? errorMessage;

  const LoginState({
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory LoginState.initial() => const LoginState(
    isSubmitting: false,
    errorMessage: null,
  );

  LoginState copyWith({
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return LoginState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage];
}