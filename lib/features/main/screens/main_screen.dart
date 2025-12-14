import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/main/cubit/main_cubit.dart';
import 'package:rkpm_5/features/main/cubit/main_state.dart';
import 'package:rkpm_5/features/main/widgets/bottom_nav.dart';
import 'package:rkpm_5/features/schedule/screens/schedule_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_screen.dart';
import 'package:rkpm_5/features/pharmacies/screens/pharmacies_screen.dart';
import 'package:rkpm_5/features/diary/screens/diary_screen.dart';
import 'package:rkpm_5/features/visits/screens/visits_screen.dart';
import 'package:rkpm_5/features/courses/screens/courses_screen.dart';
import 'package:rkpm_5/features/profile/screens/profile_screen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final pages = <Widget>[
      ScheduleScreen(),
      MedsListScreen(),
      PharmaciesScreen(),
      DiaryScreen(),
      VisitsScreen(),
      CoursesScreen(),
      ProfileScreen(),
    ];

    return BlocProvider(
      create: (_) => MainCubit(),
      child: BlocBuilder<MainCubit, MainState>(
        builder: (context, state) {
          final idx = state.selectedIndex.clamp(0, pages.length - 1);

          return Scaffold(
            body: IndexedStack(
              index: idx,
              children: pages,
            ),
            bottomNavigationBar: BottomNav(
              currentIndex: idx,
              onTap: (i) => context.read<MainCubit>().setTab(i),
            ),
          );
        },
      ),
    );
  }
}

