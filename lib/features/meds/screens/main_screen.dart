import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/state/main/main_cubit.dart';
import 'package:rkpm_5/features/meds/view/main_view.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MainCubit(),
      child: const MainView(),
    );
  }
}