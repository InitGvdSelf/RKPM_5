// lib/features/meds/screens/meds_list_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/list/list_cubit.dart';
import 'package:rkpm_5/features/meds/view/list_view.dart';

class MedsListScreen extends StatelessWidget {
  const MedsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => MedsListCubit(medsState: deps.state),
      child: const MedsListView(),
    );
  }
}