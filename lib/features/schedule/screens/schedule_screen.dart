import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/schedule/cubit/schedule_cubit.dart';
import 'package:rkpm_5/features/schedule/view/schedule_view.dart';

class ScheduleScreen extends StatelessWidget {
  const ScheduleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => ScheduleCubit(),
      child: const ScheduleView(),
    );
  }
}

