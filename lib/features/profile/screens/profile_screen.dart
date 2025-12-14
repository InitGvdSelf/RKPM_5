import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rkpm_5/features/profile/cubit/profile_cubit.dart';
import 'package:rkpm_5/features/profile/view/profile_view.dart';

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
    return BlocProvider(
      create: (_) => ProfileCubit(),
      child: const ProfileView(),
    );
  }
}

