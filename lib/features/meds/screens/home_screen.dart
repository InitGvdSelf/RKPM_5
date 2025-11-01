import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

class MedsHomeScreen extends StatefulWidget {
  final List<Medicine> medicines;
  final List<DoseEntry> doses;
  final List<DoseEntry> Function(DateTime) dosesForDay;
  final void Function(Medicine) onAddMedicine;
  final void Function(Medicine) onUpdateMedicine;
  final Medicine? Function(String) onDeleteMedicine;
  final void Function(Medicine) onRestoreMedicine;
  final void Function(String, DoseStatus) onMarkDose;
  final void Function(String, String) onSetDoseNote;
  final String Function(DateTime) fmtDate;
  final String Function(DateTime) fmtMonth;
  final String Function(DateTime) fmtTime;

  const MedsHomeScreen({
    super.key,
    required this.medicines,
    required this.doses,
    required this.dosesForDay,
    required this.onAddMedicine,
    required this.onUpdateMedicine,
    required this.onDeleteMedicine,
    required this.onRestoreMedicine,
    required this.onMarkDose,
    required this.onSetDoseNote,
    required this.fmtDate,
    required this.fmtMonth,
    required this.fmtTime,
  });

  @override
  State<MedsHomeScreen> createState() => _MedsHomeScreenState();
}

class _MedsHomeScreenState extends State<MedsHomeScreen> {
  int tabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Учёт приёма лекарственных препаратов')),
      body: IndexedStack(
        index: tabIndex,
        children: [
          ScheduleScreen(
            medicines: widget.medicines,
            dosesForDay: widget.dosesForDay,
            onMarkDose: widget.onMarkDose,
            onSetDoseNote: widget.onSetDoseNote,
            fmtDate: widget.fmtDate,
            fmtMonth: widget.fmtMonth,
            fmtTime: widget.fmtTime,
          ),
          MedsListScreen(
            medicines: widget.medicines,
            onAddMedicine: widget.onAddMedicine,
            onUpdateMedicine: widget.onUpdateMedicine,
            onDeleteMedicine: widget.onDeleteMedicine,
            onRestoreMedicine: widget.onRestoreMedicine,
          ),
          StatsScreen(
            medicines: widget.medicines,
            doses: widget.doses,
          ),
          const ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (i) => setState(() => tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Расписание'),
          NavigationDestination(icon: Icon(Icons.medication), label: 'Лекарства'),
          NavigationDestination(icon: Icon(Icons.insights), label: 'Статистика'),
          NavigationDestination(icon: Icon(Icons.person), label: 'Профиль'),
        ],
      ),
    );
  }
}