import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/screens/schedule_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

import 'package:rkpm_5/features/meds/state/main/main_cubit.dart';
import 'package:rkpm_5/features/meds/state/main/main_state.dart';

class MainView extends StatelessWidget {
  const MainView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MainCubit, MainState>(
      builder: (context, state) {
        final currentIndex = state.selectedIndex;

        final pages = <Widget>[
          const ScheduleScreen(),
          const MedsListScreen(),
          const StatsScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(index: currentIndex, children: pages),
          bottomNavigationBar: DecoratedBox(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.surface,
              border: Border(
                top: BorderSide(
                  color: Theme.of(context).dividerColor,
                  width: 1,
                ),
              ),
            ),
            child: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: currentIndex,
              onTap: (index) => context.read<MainCubit>().setTab(index),
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
                  icon: Icon(Icons.query_stats),
                  label: 'Статистика',
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: 'Профиль',
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}