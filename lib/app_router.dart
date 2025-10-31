import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/screens/navigation_choice_screen.dart';
import 'package:rkpm_5/features/meds/state/meds_container.dart';
import 'package:rkpm_5/features/meds/screens/main_menu_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/settings_screen.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

final Map<String, WidgetBuilder> appRoutes = {
  '/': (_) => const NavigationChoiceScreen(),
  '/pageview': (_) => const MedsContainer(navMode: MedsNavMode.pageView),
  '/routes': (_) => const MedsContainer(navMode: MedsNavMode.routes),

  // меню показываем как отдельный экран (опционально)
  '/menu': (_) => const MainMenuScreen(),

  // ниже — безопасные плейсхолдеры, чтобы именованные маршруты были зарегистрированы
  '/stats': (_) => const StatsScreen(meds: [], doses: []),
  '/today': (_) => TodayScreen(
    medicines: const [],
    dosesForDay: _dummyDosesForDay,
    onMarkDose: _dummyOnMarkDose,
    onSetDoseNote: _dummyOnSetDoseNote,
    fmtDate: _dummyFmt,
    fmtMonth: _dummyFmt,
    fmtTime: _dummyFmt,
  ),
  '/meds': (_) => MedsListScreen(
    medicines: const [],
    onAddMedicine: _dummyOnMed,
    onUpdateMedicine: _dummyOnMed,
    onDeleteMedicine: _dummyOnDel,
    onRestoreMedicine: _dummyOnMed,
  ),
  '/profile': (_) => const ProfileScreen(),
  '/settings': (_) => const SettingsScreen(),
};

List<DoseEntry> _dummyDosesForDay(DateTime _) => const [];
void _dummyOnMarkDose(String _, DoseStatus __) {}
void _dummyOnSetDoseNote(String _, String __) {}
String _dummyFmt(DateTime _) => '';
void _dummyOnMed(Medicine _) {}
Medicine? _dummyOnDel(String _) => null;