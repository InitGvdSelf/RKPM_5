// lib/features/meds/state/meds_list_state.dart
import 'package:equatable/equatable.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedsListState extends Equatable {
  final List<Medicine> medicines;
  final bool isLoading;
  final String? error;

  const MedsListState({
    required this.medicines,
    required this.isLoading,
    required this.error,
  });

  factory MedsListState.initial(List<Medicine> initial) {
    return MedsListState(
      medicines: List<Medicine>.from(initial),
      isLoading: false,
      error: null,
    );
  }

  MedsListState copyWith({
    List<Medicine>? medicines,
    bool? isLoading,
    String? error,
  }) {
    return MedsListState(
      medicines: medicines ?? this.medicines,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [medicines, isLoading, error];
}