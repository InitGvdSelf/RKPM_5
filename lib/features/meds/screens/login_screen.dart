// lib/features/meds/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/login/login_cubit.dart';
import 'package:rkpm_5/features/meds/view/login_view.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => LoginCubit(auth: deps.auth),
      child: const LoginView(),
    );
  }
}