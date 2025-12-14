import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/meds/cubit/meds_cubit.dart';
import 'package:rkpm_5/features/meds/view/meds_view.dart';

class MedsListScreen extends StatelessWidget {
  const MedsListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedsCubit(),
      child: const MedsListView(),
    );
  }
}
