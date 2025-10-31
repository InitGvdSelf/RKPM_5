import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/pageview_navigation_screen.dart';
import 'package:rkpm_5/features/meds/screens/main_menu_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/settings_screen.dart';

enum MedsNavMode { routes, pageView }

class MedsContainer extends StatefulWidget {
  final MedsNavMode navMode;
  const MedsContainer({super.key, this.navMode = MedsNavMode.routes});

  @override
  State<MedsContainer> createState() => _MedsContainerState();
}

class _MedsContainerState extends State<MedsContainer> {
  final List<Medicine> meds = [];
  final List<DoseEntry> doses = [];

  Medicine? _delete(String id) {
    final i = meds.indexWhere((m) => m.id == id);
    if (i < 0) return null;
    return meds.removeAt(i);
  }

  void _restore(Medicine m) => setState(() => meds.add(m));
  void _add(Medicine m) => setState(() => meds.add(m));
  void _update(Medicine m) => setState(() {});

  List<DoseEntry> _dosesForDay(DateTime d) => doses;

  String _fmtDate(DateTime d) => DateFormat('dd.MM.yyyy', 'ru_RU').format(d);
  String _fmtMonth(DateTime d) => DateFormat('LLLL yyyy', 'ru_RU').format(d);
  String _fmtTime(DateTime d) => DateFormat('HH:mm', 'ru_RU').format(d);

  bool dark = false;

  @override
  Widget build(BuildContext context) {
    if (widget.navMode == MedsNavMode.pageView) {
      return PageViewNavigationScreen(
        medicines: meds,
        doses: doses,
        dosesForDay: _dosesForDay,
        onAddMedicine: _add,
        onUpdateMedicine: _update,
        onDeleteMedicine: _delete,
        onRestoreMedicine: _restore,
        onMarkDose: (id, status) {},
        onSetDoseNote: (id, note) {},
        fmtDate: _fmtDate,
        fmtMonth: _fmtMonth,
        fmtTime: _fmtTime,
        darkMode: dark,
        onToggleDark: (v) => setState(() => dark = v),
      );
    }

    return MainMenuScreen(
      routes: <String, WidgetBuilder>{
        '/stats': (_) => StatsScreen(meds: meds, doses: doses),
        '/today': (_) => TodayScreen(
          medicines: meds,
          dosesForDay: _dosesForDay,
          onMarkDose: (id, status) {},
          onSetDoseNote: (id, note) {},
          fmtDate: _fmtDate,
          fmtMonth: _fmtMonth,
          fmtTime: _fmtTime,
        ),
        '/meds': (_) => MedsListScreen(
          medicines: meds,
          onAddMedicine: _add,
          onUpdateMedicine: _update,
          onDeleteMedicine: _delete,
          onRestoreMedicine: _restore,
        ),
        '/profile': (_) => const ProfileScreen(),
        '/settings': (_) => SettingsScreen(
          darkMode: dark,
          onToggleDark: (v) => setState(() => dark = v),
        ),
      },
    );
  }
}