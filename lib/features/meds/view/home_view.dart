import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/screens/schedule_screen.dart';
import 'package:rkpm_5/features/meds/screens/list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';

import 'package:rkpm_5/features/meds/state/home/home_cubit.dart';
import 'package:rkpm_5/features/meds/state/home/home_state.dart';

class HomeView extends StatelessWidget {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<HomeCubit, HomeState>(
      builder: (context, state) {
        final currentIndex = state.selectedIndex;

        // Наши вкладки — уже умные экраны с собственными Cubit’ами
        final pages = <Widget>[
          const ScheduleScreen(),
          const MedsListScreen(),
          const StatsScreen(),
          const ProfileScreen(),
        ];

        return Scaffold(
          body: IndexedStack(
            index: currentIndex,
            children: pages,
          ),
          bottomNavigationBar: BottomNavigationBar(
            currentIndex: currentIndex,
            onTap: (index) =>
                context.read<HomeCubit>().setTab(index),
            items: const [
              BottomNavigationBarItem(
                icon: Icon(Icons.today),
                label: 'Сегодня',
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
        );
      },
    );
  }
}