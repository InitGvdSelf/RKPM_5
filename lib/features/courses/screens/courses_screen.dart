import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/courses/cubit/courses_cubit.dart';
import 'package:rkpm_5/features/courses/view/courses_view.dart';

class CoursesScreen extends StatelessWidget {
  const CoursesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => CoursesCubit(),
      child: const CoursesView(),
    );
  }
}

