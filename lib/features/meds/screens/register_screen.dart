// lib/features/meds/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/register/register_cubit.dart';
import 'package:rkpm_5/features/meds/view/register_view.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => RegisterCubit(auth: deps.auth),
      child: const RegisterView(),
    );
  }
}