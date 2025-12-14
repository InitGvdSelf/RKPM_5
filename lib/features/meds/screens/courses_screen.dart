import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/domain/courses_repository.dart';
import 'package:rkpm_5/features/meds/state/courses/courses_cubit.dart';
import 'package:rkpm_5/features/meds/view/courses_view.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => CoursesCubit(
        repo: CoursesRepository(),
        medsState: deps.state,
      ),
      child: const CoursesView(),
    );
  }
}