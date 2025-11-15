// lib/features/meds/screens/schedule_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/schedule/schedule_cubit.dart';
import 'package:rkpm_5/features/meds/view/schedule_view.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => ScheduleCubit(medsState: deps.state),
      child: const ScheduleView(),
    );
  }
}