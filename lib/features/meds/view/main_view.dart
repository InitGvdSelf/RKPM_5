// lib/features/meds/view/main_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/screens/schedule_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_screen.dart';
import 'package:rkpm_5/features/meds/screens/pharmacies_screen.dart';
import 'package:rkpm_5/features/meds/screens/diary_screen.dart';
import 'package:rkpm_5/features/meds/screens/visits_screen.dart';
import 'package:rkpm_5/features/meds/screens/courses_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

import 'package:rkpm_5/features/meds/state/main/main_cubit.dart';
import 'package:rkpm_5/features/meds/state/main/main_state.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = const <Widget>[
      ScheduleScreen(),
      MedsListScreen(),
      PharmaciesScreen(),
      DiaryScreen(),
      VisitsScreen(),
      CoursesScreen(),
      ProfileScreen(),
    ];

    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final idx = state.selectedIndex.clamp(0, pages.length - 1);

        return Scaffold(
          body: IndexedStack(
            index: idx,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            currentIndex: idx,
            onTap: (i) => context.read<MainCubit>().setTab(i),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.calendar_month),
                label: 'Расписание',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.medication),
                label: 'Лекарства',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.local_pharmacy),
                label: 'Аптеки',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.note_alt),
                label: 'Дневник',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.event_note),
                label: 'К врачу',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.playlist_add_check),
                label: 'Курсы',
              ),
              BottomNavigationBarItem(
                icon: Icon(Icons.person),
                label: 'Профиль',
              ),
            ],
          ),
        );
      },
    );
  }
}
