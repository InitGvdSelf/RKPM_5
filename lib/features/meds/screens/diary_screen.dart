import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/domain/diary_repository.dart';
import 'package:rkpm_5/features/meds/state/diary/diary_cubit.dart';
import 'package:rkpm_5/features/meds/view/diary_view.dart';

class DiaryScreen extends StatelessWidget {
  const DiaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => DiaryCubit(repo: DiaryRepository()),
      child: const DiaryView(),
    );
  }
}