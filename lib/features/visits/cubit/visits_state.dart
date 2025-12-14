import 'package:equatable/equatable.dart';
import 'package:rkpm_5/core/models/visit_model.dart';

class VisitsState extends Equatable {
  final bool isLoading;
  final List<Visit> entries;

  const VisitsState({
    required this.isLoading,
    required this.entries,
  });

  factory VisitsState.initial() =>
      const VisitsState(isLoading: true, entries: []);

  VisitsState copyWith({
    bool? isLoading,
    List<Visit>? entries,
  }) {
    return VisitsState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [isLoading, entries];
}

