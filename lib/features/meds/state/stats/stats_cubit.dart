import 'package:bloc/bloc.dart';

import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/domain/meds_state.dart';

import 'stats_state.dart';

class StatsCubit extends Cubit<StatsState> {
  final MedsState medsState;

  StatsCubit({required this.medsState}) : super(StatsState.initial()) {
    recalculate();
  }

  void recalculate() {
    emit(state.copyWith(isLoading: true, error: null));

    try {
      final meds = medsState.medicines;
      // предполагаем, что в MedsState есть список всех доз
      final doses = medsState.doses; // List<DoseEntry>

      final totalMeds = meds.length;
      final totalDoses = doses.length;

      final taken = doses
          .where((d) => d.status == DoseStatus.taken)
          .length;
      final skipped = doses
          .where((d) => d.status == DoseStatus.skipped)
          .length;
      final pending = doses
          .where((d) => d.status == DoseStatus.pending)
          .length;

      final adherence =
      totalDoses == 0 ? 0.0 : taken / totalDoses;

      emit(
        state.copyWith(
          isLoading: false,
          totalMeds: totalMeds,
          totalDoses: totalDoses,
          takenDoses: taken,
          skippedDoses: skipped,
          pendingDoses: pending,
          adherence: adherence,
        ),
      );
    } catch (e) {
      emit(
        state.copyWith(
          isLoading: false,
          error: 'Не удалось пересчитать статистику',
        ),
      );
    }
  }
}