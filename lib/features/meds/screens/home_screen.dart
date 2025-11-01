import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

class MedsHomeScreen extends StatelessWidget {
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

  void _openSchedule(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ScheduleScreen(
          medicines: medicines,
          dosesForDay: dosesForDay,
          onMarkDose: onMarkDose,
          onSetDoseNote: onSetDoseNote,
          fmtDate: fmtDate,
          fmtMonth: fmtMonth,
          fmtTime: fmtTime,
        ),
      ),
    );
  }

  void _openMeds(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => MedsListScreen(
          medicines: medicines,
          onAddMedicine: onAddMedicine,
          onUpdateMedicine: onUpdateMedicine,
          onDeleteMedicine: onDeleteMedicine,
          onRestoreMedicine: onRestoreMedicine,
        ),
      ),
    );
  }

  void _openStats(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => StatsScreen(
          medicines: medicines,
          doses: doses,
        ),
      ),
    );
  }

  void _openProfile(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ProfileScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Учёт приёма лекарственных препаратов')),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              FilledButton.icon(
                onPressed: () => _openSchedule(context),
                icon: const Icon(Icons.calendar_month),
                label: const Text('Расписание'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openMeds(context),
                icon: const Icon(Icons.medication),
                label: const Text('Лекарства'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openStats(context),
                icon: const Icon(Icons.insights),
                label: const Text('Статистика'),
              ),
              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: () => _openProfile(context),
                icon: const Icon(Icons.person),
                label: const Text('Профиль'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}