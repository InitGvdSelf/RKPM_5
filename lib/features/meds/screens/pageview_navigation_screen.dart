import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/settings_screen.dart';

class PageViewNavigationScreen extends StatefulWidget {
  final List<Medicine> medicines;
  final List doses;
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
  final bool darkMode;
  final ValueChanged<bool> onToggleDark;

  const PageViewNavigationScreen({
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
    required this.darkMode,
    required this.onToggleDark,
  });

  @override
  State<PageViewNavigationScreen> createState() => _PageViewNavigationScreenState();
}

class _PageViewNavigationScreenState extends State<PageViewNavigationScreen> {
  final controller = PageController();
  int index = 0;

  @override
  Widget build(BuildContext context) {
    final pages = <_TabPage>[
      _TabPage(
        title: 'Статистика',
        icon: Icons.home,
        builder: (_) => StatsScreen(meds: widget.medicines, doses: widget.doses, embedded: true),
      ),
      _TabPage(
        title: 'Сегодня',
        icon: Icons.calendar_month,
        builder: (_) => TodayScreen(
          medicines: widget.medicines,
          dosesForDay: widget.dosesForDay,
          onMarkDose: widget.onMarkDose,
          onSetDoseNote: widget.onSetDoseNote,
          fmtDate: widget.fmtDate,
          fmtMonth: widget.fmtMonth,
          fmtTime: widget.fmtTime,
          embedded: true,
        ),
      ),
      _TabPage(
        title: 'Лекарства',
        icon: Icons.medication,
        builder: (_) => MedsListScreen(
          medicines: widget.medicines,
          onAddMedicine: widget.onAddMedicine,
          onUpdateMedicine: widget.onUpdateMedicine,
          onDeleteMedicine: widget.onDeleteMedicine,
          onRestoreMedicine: widget.onRestoreMedicine,
          embedded: true,
        ),
      ),
      _TabPage(
        title: 'Профиль',
        icon: Icons.person,
        builder: (_) => const ProfileScreen(embedded: true),
      ),
      _TabPage(
        title: 'Настройки',
        icon: Icons.settings,
        builder: (_) => SettingsScreen(
          darkMode: widget.darkMode,
          onToggleDark: widget.onToggleDark,
          embedded: true,
        ),
      ),
    ];

    return Scaffold(
      appBar: AppBar(title: Text(pages[index].title)),
      body: Column(
        children: [
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(
              pages.length,
                  (i) => AnimatedContainer(
                duration: const Duration(milliseconds: 220),
                margin: const EdgeInsets.symmetric(horizontal: 6),
                width: i == index ? 36 : 8,
                height: 8,
                decoration: BoxDecoration(
                  color: i == index ? const Color(0xFF495A9C) : Colors.black12,
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: PageView(
              controller: controller,
              onPageChanged: (i) => setState(() => index = i),
              children: pages.map((p) => p.builder(context)).toList(),
            ),
          ),
        ],
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: index,
        onTap: (i) {
          controller.animateToPage(i, duration: const Duration(milliseconds: 260), curve: Curves.easeOut);
          setState(() => index = i);
        },
        items: pages.map((p) => BottomNavigationBarItem(icon: Icon(p.icon), label: p.title)).toList(),
      ),
    );
  }
}

class _TabPage {
  final String title;
  final IconData icon;
  final WidgetBuilder builder;
  _TabPage({required this.title, required this.icon, required this.builder});
}