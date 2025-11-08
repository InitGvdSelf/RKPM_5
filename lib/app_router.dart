// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/auth_service.dart';

import 'package:rkpm_5/features/meds/screens/login_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';

abstract class Routes {
  static const login    = '/login';
  static const profile  = '/profile';
  static const schedule = '/schedule';
  static const meds     = '/meds';
  static const stats    = '/stats';
}

class AppRouter {
  final MedsState state;
  late final GoRouter router;

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
          builder: (context, state) => const LoginScreen(),
        ),
        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: Routes.schedule,
          name: 'schedule',
          builder: (context, stateGo) {
            this.state.ensureFutureDoses();
            return const ScheduleScreen();
          },
        ),
        GoRoute(
          path: Routes.meds,
          name: 'meds',
          builder: (context, state) => const MedsListScreen(),
        ),
        GoRoute(
          path: Routes.stats,
          name: 'stats',
          builder: (context, state) => const StatsScreen(),
        ),
      ],
    );
  }
}