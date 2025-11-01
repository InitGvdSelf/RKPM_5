import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/state/meds_state.dart';

class MedsNavigator {
  final MedsState state;

  MedsNavigator(this.state);

  void openToday(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => ScheduleScreen(
        medicines: state.medicines,
        dosesForDay: (d) => state.doses
            .where((x) =>
        x.plannedAt.year == d.year &&
            x.plannedAt.month == d.month &&
            x.plannedAt.day == d.day)
            .toList(),
        onMarkDose: (id, s) {},
        onSetDoseNote: (id, note) {},
        fmtDate: state.fmtDate,
        fmtMonth: state.fmtMonth,
        fmtTime: state.fmtTime,
      ),
    ));
  }

  void openMeds(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => MedsListScreen(
        medicines: state.medicines,
        onAddMedicine: state.addMedicine,
        onUpdateMedicine: state.updateMedicine,
        onDeleteMedicine: state.deleteMedicine,
        onRestoreMedicine: state.restoreMedicine,
      ),
    ));
  }

  void openStats(BuildContext context) {
    Navigator.push(context, MaterialPageRoute(
      builder: (_) => StatsScreen(
        medicines: state.medicines,
        doses: state.doses,
      ),
    ));
  }
}