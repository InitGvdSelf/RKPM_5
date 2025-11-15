// lib/features/meds/state/profile_state.dart
import 'package:equatable/equatable.dart';
import 'package:rkpm_5/features/meds/models/profile.dart';

class ProfileState extends Equatable {
  final Profile? profile;
  final bool isLoading;
  final bool isSaving;
  final String? error;

  const ProfileState({
    required this.profile,
    required this.isLoading,
    required this.isSaving,
    required this.error,
  });

  factory ProfileState.initial() => const ProfileState(
    profile: null,
    isLoading: true,
    isSaving: false,
    error: null,
  );

  ProfileState copyWith({
    Profile? profile,
    bool? isLoading,
    bool? isSaving,
    String? error,
  }) {
    return ProfileState(
      profile: profile ?? this.profile,
      isLoading: isLoading ?? this.isLoading,
      isSaving: isSaving ?? this.isSaving,
      error: error,
    );
  }

  @override
  List<Object?> get props => [profile, isLoading, isSaving, error];
}