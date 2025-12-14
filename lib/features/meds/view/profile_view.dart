// lib/features/meds/view/profile_view.dart
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app/app_router.dart';
import 'package:rkpm_5/features/meds/state/profile/profile_cubit.dart';
import 'package:rkpm_5/features/meds/state/profile/profile_state.dart';

class ProfileView extends StatefulWidget {
  const ProfileView({super.key});

  @override
  State<ProfileView> createState() => _ProfileViewState();
}

class _ProfileViewState extends State<ProfileView> {
  late final TextEditingController nameCtrl;
  late final TextEditingController ageCtrl;

  bool _initialized = false;

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
    await cubit.saveProfile(name: nameCtrl.text, ageText: ageCtrl.text);

    if (!mounted) return;

    final err = cubit.state.error;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(err ?? 'Профиль сохранён')),
    );
  }

  Future<void> _changeAvatar(ProfileCubit cubit) async {
    await cubit.changeAvatar(name: nameCtrl.text, ageText: ageCtrl.text);
    if (!mounted) return;
    if (cubit.state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cubit.state.error!)),
      );
    }
  }

  Future<void> _signOut(ProfileCubit cubit) async {
    await cubit.signOut();
    if (!mounted) return;
    context.go(Routes.authWithMode('login'));
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (!_initialized && state.profile != null) {
          _initialized = true;
          final p = state.profile!;
          nameCtrl.text = p.name;
          ageCtrl.text = p.age > 0 ? p.age.toString() : '';
        }
      },
      builder: (context, state) {
        final cubit = context.read<ProfileCubit>();
        final p = state.profile;

        if (state.isLoading && !_initialized) {
          return const Scaffold(body: Center(child: CircularProgressIndicator()));
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text('Профиль'),
            actions: [
              IconButton(
                tooltip: 'Настройки',
                onPressed: () => context.push(Routes.settings),
                icon: const Icon(Icons.settings),
              ),
            ],
          ),
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
                      child: (p?.avatarUrl != null)
                          ? CachedNetworkImage(
                        imageUrl: p!.avatarUrl!,
                        width: 120,
                        height: 120,
                        fit: BoxFit.cover,
                        placeholder: (_, __) =>
                        const Center(child: CircularProgressIndicator(strokeWidth: 2)),
                        errorWidget: (_, __, ___) =>
                        const Icon(Icons.person, size: 48),
                      )
                          : const Icon(Icons.person, size: 48),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 24),

              Text('Личные данные', style: theme.textTheme.titleMedium),
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
                label: const Text('Сохранить'),
              ),

              const SizedBox(height: 24),
              const Divider(),
              const SizedBox(height: 12),

              FilledButton.icon(
                style: FilledButton.styleFrom(
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                ),
                onPressed: state.isSaving ? null : () => _signOut(cubit),
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