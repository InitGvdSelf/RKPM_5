import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/profile/profile_cubit.dart';
import 'package:rkpm_5/features/meds/view/profile_view.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.onOpenToday,
    this.onOpenMeds,
    this.onOpenStats,
  });

  final VoidCallback? onOpenToday;
  final VoidCallback? onOpenMeds;
  final VoidCallback? onOpenStats;

  @override
  Widget build(BuildContext context) {
    final deps = AppDependencies.of(context);

    return BlocProvider(
      create: (_) => ProfileCubit(
        auth: deps.auth,
        images: deps.images,
      ),
      child: ProfileView(
        onOpenToday: onOpenToday,
        onOpenMeds: onOpenMeds,
        onOpenStats: onOpenStats,
      ),
    );
  }
}