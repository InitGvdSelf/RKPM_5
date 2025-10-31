import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/features/meds/screens/navigation_choice_screen.dart';
import 'package:rkpm_5/features/meds/state/meds_container.dart';
import 'package:rkpm_5/features/meds/screens/pageview_navigation_screen.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (context, state) => const NavigationChoiceScreen(),
    ),
    GoRoute(
      path: '/app',
      builder: (context, state) => const MedsContainer(),
    ),
    GoRoute(
      path: '/pageview',
      builder: (context, state) => const PageViewNavigationScreen(),
    ),
  ],
);