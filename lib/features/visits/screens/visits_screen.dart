import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/visits/cubit/visits_cubit.dart';
import 'package:rkpm_5/features/visits/view/visits_view.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VisitsCubit(),
      child: const VisitsView(),
    );
  }
}

