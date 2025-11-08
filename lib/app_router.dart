import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/core/di.dart';
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
  late final GoRouter router;
  AppRouter() {
    router = GoRouter(
      initialLocation: Routes.profile,
      redirect: (context, s) async {
        final signedIn = await sl<AuthService>().isSignedIn();
        final goingToLogin = s.matchedLocation == Routes.login;
        if (!signedIn && !goingToLogin) return Routes.login;
        if (signedIn && goingToLogin) return Routes.profile;
        return null;
      },
      routes: [
        GoRoute(path: Routes.login,    builder: (_, __) => const LoginScreen()),
        GoRoute(path: Routes.profile,  builder: (_, __) => const ProfileScreen()),
        GoRoute(
          path: Routes.schedule,
          builder: (_, __) {
            return const ScheduleScreen();
          },
        ),
        GoRoute(path: Routes.meds,  builder: (_, __) => const MedsListScreen()),
        GoRoute(path: Routes.stats, builder: (_, __) => const StatsScreen()),
      ],
    );
  }
}