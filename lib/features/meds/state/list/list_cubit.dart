// lib/features/meds/state/meds_list_cubit.dart
import 'package:bloc/bloc.dart';

import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/domain/meds_state.dart';

import 'list_state.dart';

class MedsListCubit extends Cubit<MedsListState> {
  final MedsState medsState;

  MedsListCubit({required this.medsState})
      : super(MedsListState.initial(medsState.medicines));

  void refresh() {
    emit(
      state.copyWith(
        medicines: List<Medicine>.from(medsState.medicines),
        isLoading: false,
        error: null,
      ),
    );
  }

  void addMedicine(Medicine m) {
    medsState.addMedicine(m);
    refresh();
  }

  void updateMedicine(Medicine m) {
    medsState.updateMedicine(m);
    refresh();
  }

  Medicine? deleteMedicine(String id) {
    final removed = medsState.deleteMedicine(id);
    refresh();
    return removed;
  }

  void restoreMedicine(Medicine m) {
    medsState.restoreMedicine(m);
    refresh();
  }
}