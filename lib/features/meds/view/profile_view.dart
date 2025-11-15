// lib/features/meds/view/profile_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/features/meds/state/profile/profile_cubit.dart';
import 'package:rkpm_5/features/meds/state/profile/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({
    super.key,
    this.onOpenToday,
    this.onOpenMeds,
    this.onOpenStats,
  });

  final VoidCallback? onOpenToday;
  final VoidCallback? onOpenMeds;
  final VoidCallback? onOpenStats;

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController nameCtrl;
  late final TextEditingController ageCtrl;

  bool _initializedFromState = false;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    ageCtrl = TextEditingController();
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  Future<void> _save(ProfileCubit cubit) async {
    await cubit.saveProfile(
      name: nameCtrl.text,
      ageText: ageCtrl.text,
    );

    if (!mounted) return;
    final state = cubit.state;
    if (state.error == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Профиль сохранён')),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(state.error!)),
      );
    }
  }

  Future<void> _changeAvatar(ProfileCubit cubit) async {
    await cubit.changeAvatar(
      name: nameCtrl.text,
      ageText: ageCtrl.text,
    );
  }

  Future<void> _signOut(ProfileCubit cubit) async {
    await cubit.signOut();
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (!_initializedFromState && state.profile != null) {
          _initializedFromState = true;
          final p = state.profile!;
          nameCtrl.text = p.name;
          ageCtrl.text = p.age > 0 ? p.age.toString() : '';
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final profile = state.profile;
        final avatarUrl = profile?.avatarUrl;

        if (state.isLoading && !_initializedFromState) {
          return const Scaffold(
            body: Center(child: CircularProgressIndicator()),
          );
        }

        return Scaffold(
          appBar: AppBar(title: const Text('Профиль')),
          body: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              Center(
                child: GestureDetector(
                  onTap: () => _changeAvatar(cubit),
                  child: CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey.shade300,
                    child: ClipOval(
                      child: avatarUrl != null
                          ? CachedNetworkImage(
                        imageUrl: avatarUrl,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        fadeInDuration:
                        const Duration(milliseconds: 200),
                        placeholder: (context, url) => const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        ),
                        errorWidget: (context, url, error) =>
                        const Icon(Icons.person, size: 48),
                      )
                          : const Icon(
                        Icons.person,
                        size: 48,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 24),
              Text(
                'Личные данные',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              TextField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Имя',
                  border: OutlineInputBorder(),
                ),
              ),
              const SizedBox(height: 12),
              TextField(
                controller: ageCtrl,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Возраст',
                  border: OutlineInputBorder(),
                ),
              ),

              const SizedBox(height: 16),
              FilledButton.icon(
                onPressed: state.isSaving ? null : () => _save(cubit),
                icon: const Icon(Icons.save),
                label: const Text('Сохранить изменения'),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              Text(
                'Навигация',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),

              FilledButton.tonalIcon(
                onPressed: widget.onOpenToday ??
                        () => context.push(Routes.schedule),
                icon: const Icon(Icons.calendar_today),
                label: const Text('Расписание'),
              ),
              const SizedBox(height: 8),

              FilledButton.tonalIcon(
                onPressed: widget.onOpenMeds ??
                        () => context.push(Routes.meds),
                icon: const Icon(Icons.medication),
                label: const Text('Лекарства'),
              ),
              const SizedBox(height: 8),

              FilledButton.tonalIcon(
                onPressed: widget.onOpenStats ??
                        () => context.push(Routes.stats),
                icon: const Icon(Icons.query_stats),
                label: const Text('Статистика'),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              FilledButton.icon(
                onPressed: () => _signOut(cubit),
                icon: const Icon(Icons.logout),
                label: const Text('Выйти из аккаунта'),
              ),
            ],
          ),
        );
      },
    );
  }
}