import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/domain/usecases/schedule/get_day_schedule_usecase.dart';
import 'package:rkpm_5/domain/usecases/schedule/mark_dose_usecase.dart';
import 'package:rkpm_5/domain/usecases/schedule/set_dose_note_usecase.dart';
import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final GetDayScheduleUseCase getDayScheduleUseCase;
  final MarkDoseUseCase markDoseUseCase;
  final SetDoseNoteUseCase setDoseNoteUseCase;

  ScheduleCubit({
    GetDayScheduleUseCase? getDayScheduleUseCase,
    MarkDoseUseCase? markDoseUseCase,
    SetDoseNoteUseCase? setDoseNoteUseCase,
  })  : getDayScheduleUseCase = getDayScheduleUseCase ?? DI.getDayScheduleUseCase,
        markDoseUseCase = markDoseUseCase ?? DI.markDoseUseCase,
        setDoseNoteUseCase = setDoseNoteUseCase ?? DI.setDoseNoteUseCase,
        super(ScheduleState.initial());

  void previousMonth() {
    final d = state.selectedDate;
    final newDate = DateTime(d.year, d.month - 1, 1);
    emit(state.copyWith(selectedDate: newDate));
  }

  void nextMonth() {
    final d = state.selectedDate;
    final newDate = DateTime(d.year, d.month + 1, 1);
    emit(state.copyWith(selectedDate: newDate));
  }

  void goToday() {
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day);
    emit(state.copyWith(selectedDate: today));
  }

  void setSelectedDate(DateTime date) {
    final normalized = DateTime(date.year, date.month, date.day);
    emit(state.copyWith(selectedDate: normalized));
  }

  Future<void> markDose(String doseId, DoseStatus status) async {
    final result = await markDoseUseCase(doseId, status);
    result.fold(
      (_) {},
      (_) => emit(state.copyWith(revision: state.revision + 1)),
    );
  }

  Future<void> updateDoseNote(String doseId, String note) async {
    final result = await setDoseNoteUseCase(doseId, note);
    result.fold(
      (_) {},
      (_) => emit(state.copyWith(revision: state.revision + 1)),
    );
  }
}

