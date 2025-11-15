import 'package:bloc/bloc.dart';
import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

import 'schedule_state.dart';

class ScheduleCubit extends Cubit<ScheduleState> {
  final MedsState medsState;

  ScheduleCubit({required this.medsState})
      : super(ScheduleState.initial()) {
    medsState.ensureFutureDoses();
  }

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

  void markDose(String doseId, DoseStatus status) {
    medsState.markDose(doseId, status);
    emit(state.copyWith(revision: state.revision + 1));
  }

  void updateDoseNote(String doseId, String note) {
    medsState.setDoseNote(doseId, note);
    emit(state.copyWith(revision: state.revision + 1));
  }
}