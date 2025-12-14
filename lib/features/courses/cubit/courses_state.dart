import 'package:equatable/equatable.dart';
import 'package:rkpm_5/core/models/course_model.dart';

class CoursesState extends Equatable {
  final bool isLoading;
  final List<MedCourse> entries;

  const CoursesState({
    required this.isLoading,
    required this.entries,
  });

  factory CoursesState.initial() =>
      const CoursesState(isLoading: true, entries: []);

  CoursesState copyWith({
    bool? isLoading,
    List<MedCourse>? entries,
  }) {
    return CoursesState(
      isLoading: isLoading ?? this.isLoading,
      entries: entries ?? this.entries,
    );
  }

  @override
  List<Object?> get props => [isLoading, entries];
}

