import 'package:equatable/equatable.dart';
import 'package:rkpm_5/core/models/diary_entry_model.dart';

class DiaryState extends Equatable {
  final bool isLoading;
  final List<DiaryEntry> entries;

  const DiaryState({
    required this.isLoading,
    required this.entries,
  });

  factory DiaryState.initial() => const DiaryState(isLoading: true, entries: []);

  DiaryState copyWith({
    bool? isLoading,
    List<DiaryEntry>? entries,
  }) {
    return DiaryState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [isLoading, entries];
}

