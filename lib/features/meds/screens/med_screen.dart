import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/core/models/medicine_model.dart';
import 'package:rkpm_5/features/meds/cubit/med_form_cubit.dart';
import 'package:rkpm_5/features/meds/view/med_view.dart';

class MedScreen extends StatelessWidget {
  final Medicine? existing;

  const MedScreen({super.key, this.existing});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => MedFormCubit(existing: existing),
      child: const MedFormView(),
    );
  }
}

