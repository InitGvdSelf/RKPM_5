// lib/features/meds/screens/meds_home_screen.dart
import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

class MedsHomeScreen extends StatefulWidget {
  const MedsHomeScreen({super.key});

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
        children: const [
          ScheduleScreen(),  // всё берут зависимости из GetIt внутри
          MedsListScreen(),
          StatsScreen(),
          ProfileScreen(),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: tabIndex,
        onDestinationSelected: (i) => setState(() => tabIndex = i),
        destinations: const [
          NavigationDestination(icon: Icon(Icons.calendar_month), label: 'Расписание'),
          NavigationDestination(icon: Icon(Icons.medication),     label: 'Лекарства'),
          NavigationDestination(icon: Icon(Icons.insights),       label: 'Статистика'),
          NavigationDestination(icon: Icon(Icons.person),         label: 'Профиль'),
        ],
      ),
    );
  }
}