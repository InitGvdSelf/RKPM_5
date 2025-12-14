import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/domain/visits_repository.dart';
import 'package:rkpm_5/features/meds/state/visits/visits_cubit.dart';
import 'package:rkpm_5/features/meds/view/visits_view.dart';

class VisitsScreen extends StatelessWidget {
  const VisitsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => VisitsCubit(repo: VisitsRepository()),
      child: const VisitsView(),
    );
  }
}