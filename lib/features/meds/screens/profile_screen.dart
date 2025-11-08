// lib/features/meds/screens/profile_screen.dart
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

import 'package:rkpm_5/features/meds/models/profile.dart';
import 'package:rkpm_5/features/meds/state/profile_storage.dart';

class ProfileScreen extends StatefulWidget {
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
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late final TextEditingController nameCtrl;
  late final TextEditingController ageCtrl;
  Profile? profile;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    ageCtrl  = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final stored = await ProfileStorage.load();
    if (!mounted) return;
    setState(() {
      profile = stored ?? Profile(name: '', age: 0, avatarUrl: null);
      nameCtrl.text = profile!.name;
      ageCtrl.text  = profile!.age > 0 ? profile!.age.toString() : '';
    });
  }

  Future<void> _save() async {
    final updated = Profile(
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      avatarUrl: profile?.avatarUrl,
    );
    await ProfileStorage.save(updated);
    if (!mounted) return;
    setState(() => profile = updated);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранён')),
    );
  }

  Future<void> _changeAvatar() async {
    final images = AppDependencies.of(context).images; // через провайдер
    final url = await images.nextAvatarImage();
    final updated = Profile(
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      avatarUrl: url,
    );
    await ProfileStorage.save(updated);
    if (!mounted) return;
    setState(() => profile = updated);
  }

  Future<void> _signOut() async {
    final auth = AppDependencies.of(context).auth; // через провайдер
    await auth.signOut();
    if (!mounted) return;
    context.go(Routes.login);
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final avatarUrl = profile?.avatarUrl;
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Center(
            child: GestureDetector(
              onTap: _changeAvatar,
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
                    placeholder: (_, __) => const Padding(
                      padding: EdgeInsets.all(12),
                      child: CircularProgressIndicator(strokeWidth: 2),
                    ),
                    errorWidget: (_, __, ___) =>
                    const Icon(Icons.person, size: 60),
                  )
                      : const Icon(Icons.person, size: 60),
                ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          TextField(
            controller: nameCtrl,
            decoration: const InputDecoration(labelText: 'Имя'),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: ageCtrl,
            decoration: const InputDecoration(labelText: 'Возраст'),
            keyboardType: TextInputType.number,
          ),
          const SizedBox(height: 16),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Сохранить'),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          Text('Разделы', style: theme.textTheme.titleMedium),
          const SizedBox(height: 8),

          FilledButton.tonalIcon(
            onPressed: widget.onOpenToday ?? () => context.push(Routes.schedule),
            icon: const Icon(Icons.calendar_today),
            label: const Text('Расписание'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: widget.onOpenMeds ?? () => context.push(Routes.meds),
            icon: const Icon(Icons.medication),
            label: const Text('Лекарства'),
          ),
          const SizedBox(height: 8),
          FilledButton.tonalIcon(
            onPressed: widget.onOpenStats ?? () => context.push(Routes.stats),
            icon: const Icon(Icons.query_stats),
            label: const Text('Статистика'),
          ),

          const SizedBox(height: 24),
          const Divider(),
          const SizedBox(height: 12),

          FilledButton.icon(
            onPressed: _signOut,
            icon: const Icon(Icons.logout),
            label: const Text('Выйти из аккаунта'),
          ),
        ],
      ),
    );
  }
}