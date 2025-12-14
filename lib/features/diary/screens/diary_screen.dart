import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/diary/cubit/diary_cubit.dart';
import 'package:rkpm_5/features/diary/view/diary_view.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiaryCubit(),
      child: const DiaryView(),
    );
  }
}

