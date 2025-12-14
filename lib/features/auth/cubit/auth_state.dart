import 'package:equatable/equatable.dart';

class AuthState extends Equatable {
  final bool isSubmitting;
  final String? errorMessage;

  const AuthState({
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory AuthState.initial() => const AuthState(
    isSubmitting: false,
    errorMessage: null,
  );

  AuthState copyWith({
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return AuthState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage];
}

