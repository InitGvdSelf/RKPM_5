import 'package:equatable/equatable.dart';

class ScheduleState extends Equatable {
  final DateTime selectedDate;
  final int revision; // чтобы форсить rebuild, когда поменялись дозы

  const ScheduleState({
    required this.selectedDate,
    required this.revision,
  });

  factory ScheduleState.initial() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    return ScheduleState(
      selectedDate: today,
      revision: 0,
    );
  }

  ScheduleState copyWith({
    DateTime? selectedDate,
    int? revision,
  }) {
    return ScheduleState(
      selectedDate: selectedDate ?? this.selectedDate,
      revision: revision ?? this.revision,
    );
  }

  @override
  List<Object?> get props => [selectedDate, revision];
}