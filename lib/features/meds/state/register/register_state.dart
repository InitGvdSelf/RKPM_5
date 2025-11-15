// lib/features/meds/state/register_state.dart
import 'package:equatable/equatable.dart';

class RegisterState extends Equatable {
  final bool isSubmitting;
  final String? errorMessage;

  const RegisterState({
    required this.isSubmitting,
    required this.errorMessage,
  });

  factory RegisterState.initial() => const RegisterState(
    isSubmitting: false,
    errorMessage: null,
  );

  RegisterState copyWith({
    bool? isSubmitting,
    String? errorMessage,
  }) {
    return RegisterState(
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [isSubmitting, errorMessage];
}