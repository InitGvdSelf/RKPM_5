// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/screens/login_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/state/auth_service.dart';

abstract class Routes {
  static const login    = '/login';
  static const profile  = '/profile';
  static const schedule = '/schedule';
  static const meds     = '/meds';
  static const stats    = '/stats';
}

class AppRouter {
  final MedsState state;

  AppRouter(this.state) {
    router = GoRouter(
      initialLocation: Routes.profile,
      redirect: (context, s) async {
        final signedIn = await AuthService.instance.isSignedIn();
        final goingToLogin = s.matchedLocation == Routes.login;

        if (!signedIn && !goingToLogin) return Routes.login;
        if (signedIn && goingToLogin) return Routes.profile;
        return null;
      },
      routes: [
        GoRoute(
          path: Routes.login,
          name: 'login',
          builder: (_, __) => const LoginScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (ctx, __) => ProfileScreen(
            onOpenToday: () => ctx.pushNamed('schedule'),
            onOpenMeds:  () => ctx.pushNamed('meds'),
            onOpenStats: () => ctx.pushNamed('stats'),
          ),
        ),
        GoRoute(
          path: Routes.schedule,
          name: 'schedule',
          builder: (_, __) {
            state.ensureFutureDoses();

            return ScheduleScreen(
              medicines: state.medicines,
              dosesForDay: state.dosesForDay,
              onMarkDose: state.markDose,
              onSetDoseNote: state.setDoseNote,
              fmtDate: state.fmtDate,
              fmtMonth: state.fmtMonth,
              fmtTime: state.fmtTime,
            );
          },
        ),
        GoRoute(
          path: Routes.meds,
          name: 'meds',
          builder: (_, __) => MedsListScreen(
            medicines: state.medicines,
            onAddMedicine: state.addMedicine,
            onUpdateMedicine: state.updateMedicine,
            onDeleteMedicine: state.deleteMedicine,
            onRestoreMedicine: state.restoreMedicine,
          ),
        ),
        GoRoute(
          path: Routes.stats,
          name: 'stats',
          builder: (_, __) => StatsScreen(
            medicines: state.medicines,
            doses: state.doses,
          ),
        ),
      ],
    );
  }

  late final GoRouter router;
}