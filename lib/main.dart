import 'package:flutter/material.dart';
import 'package:bloc/bloc.dart';
import 'package:rkpm_5/app/app.dart';
import 'package:rkpm_5/app/app_router.dart';
import 'package:rkpm_5/app/di.dart';
import 'package:rkpm_5/app/bloc_observer.dart';
import 'package:rkpm_5/core/services/image_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize DI
  await DI.init();

  // Initialize BlocObserver
  Bloc.observer = AppBlocObserver();

  // Initialize services
  await ImageService.instance.initialize();

  // Restore auth session (if needed)
  await DI.authRepository.getCurrentUser();

  final appRouter = AppRouter();

  // Theme controller is initialized in DI.init() and loads saved preference
  final theme = DI.themeController;

  runApp(
    RKPMApp(router: appRouter.router, theme: theme),
  );
}
