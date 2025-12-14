import 'package:equatable/equatable.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';

class MedsState extends Equatable {
  final List<Medicine> medicines;
  final bool isLoading;
  final String? error;

  const MedsState({
    required this.medicines,
    required this.isLoading,
    required this.error,
  });

  factory MedsState.initial() {
    return const MedsState(
      medicines: [],
      isLoading: false,
      error: null,
    );
  }

  MedsState copyWith({
    List<Medicine>? medicines,
    bool? isLoading,
    String? error,
  }) {
    return MedsState(
      medicines: medicines ?? this.medicines,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [medicines, isLoading, error];
}

