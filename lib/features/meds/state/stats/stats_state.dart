import 'package:equatable/equatable.dart';

class StatsState extends Equatable {
  final int totalMeds;      // всего лекарств
  final int totalDoses;     // всего доз
  final int takenDoses;     // принятых
  final int skippedDoses;   // пропущенных
  final int pendingDoses;   // ожидающих
  final double adherence;   // приверженность (0..1)
  final bool isLoading;
  final String? error;

  const StatsState({
    required this.totalMeds,
    required this.totalDoses,
    required this.takenDoses,
    required this.skippedDoses,
    required this.pendingDoses,
    required this.adherence,
    required this.isLoading,
    required this.error,
  });

  factory StatsState.initial() => const StatsState(
    totalMeds: 0,
    totalDoses: 0,
    takenDoses: 0,
    skippedDoses: 0,
    pendingDoses: 0,
    adherence: 0.0,
    isLoading: false,
    error: null,
  );

  StatsState copyWith({
    int? totalMeds,
    int? totalDoses,
    int? takenDoses,
    int? skippedDoses,
    int? pendingDoses,
    double? adherence,
    bool? isLoading,
    String? error,
  }) {
    return StatsState(
      totalMeds: totalMeds ?? this.totalMeds,
      totalDoses: totalDoses ?? this.totalDoses,
      takenDoses: takenDoses ?? this.takenDoses,
      skippedDoses: skippedDoses ?? this.skippedDoses,
      pendingDoses: pendingDoses ?? this.pendingDoses,
      adherence: adherence ?? this.adherence,
      isLoading: isLoading ?? this.isLoading,
      error: error,
    );
  }

  @override
  List<Object?> get props => [
    totalMeds,
    totalDoses,
    takenDoses,
    skippedDoses,
    pendingDoses,
    adherence,
    isLoading,
    error,
  ];
}