import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/stats/cubit/stats_cubit.dart';
import 'package:rkpm_5/features/stats/view/stats_view.dart';

class StatsScreen extends StatelessWidget {
  const StatsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => StatsCubit(),
      child: const StatsView(),
    );
  }
}

