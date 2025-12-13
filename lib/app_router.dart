// lib/app_router.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';
import 'package:rkpm_5/features/meds/models/medicine.dart';

import 'package:rkpm_5/features/meds/screens/login_screen.dart';
import 'package:rkpm_5/features/meds/screens/register_screen.dart';
import 'package:rkpm_5/features/meds/screens/pharmacies_screen.dart';
import 'package:rkpm_5/features/meds/screens/main_screen.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/schedule_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_screen.dart';
import 'package:rkpm_5/features/meds/screens/med_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/settings_screen.dart';

abstract class Routes {
  static const auth = '/auth';
  static const main = '/main';
  static const pharmacies = '/pharmacies';
  static const profile = '/profile';
  static const schedule = '/schedule';
  static const meds = '/meds';
  static const med = '/med';
  static const stats = '/stats';
  static const settings = '/settings';

  static String authWithMode([String mode = 'login']) => '$auth?mode=$mode';
}

class AppRouter {
  final MedsState state;
  late final GoRouter router;

  AppRouter(this.state) {
    router = GoRouter(
      initialLocation: Routes.authWithMode('login'),
      redirect: (context, s) async {
        final signedIn = await AuthService.instance.isSignedIn();
        final goingToAuth = s.matchedLocation == Routes.auth;

        if (!signedIn && !goingToAuth) {
          return Routes.authWithMode('login');
        }

        if (signedIn && goingToAuth) {
          return Routes.main;
        }

        return null;
      },
      routes: [
        GoRoute(
          path: Routes.auth,
          name: 'auth',
          builder: (context, state) {
            final mode = state.uri.queryParameters['mode'] ?? 'login';
            return mode == 'register'
                ? const RegisterScreen()
                : const LoginScreen();
          },
        ),

        GoRoute(
          path: Routes.main,
          name: 'main',
          builder: (context, state) => const MainScreen(),
        ),

        GoRoute(
          path: Routes.profile,
          name: 'profile',
          builder: (context, state) => const ProfileScreen(),
        ),
        GoRoute(
          path: Routes.schedule,
          name: 'schedule',
          builder: (context, state) => const ScheduleScreen(),
        ),
        GoRoute(
          path: Routes.meds,
          name: 'meds',
          builder: (context, state) => const MedsListScreen(),
        ),
        GoRoute(
          path: Routes.med,
          name: 'med',
          builder: (context, state) {
            final existing =
            state.extra is Medicine ? state.extra as Medicine : null;
            return MedFormScreen(existing: existing);
          },
        ),
        GoRoute(
          path: Routes.stats,
          name: 'stats',
          builder: (context, state) => const StatsScreen(),
        ),
        GoRoute(
          path: Routes.settings,
          name: 'settings',
          builder: (context, state) => const SettingsScreen(),
        ),
        GoRoute(
          path: Routes.pharmacies,
          name: 'pharmacies',
          builder: (context, state) => const PharmaciesScreen(),
        ),
      ],
    );
  }
}