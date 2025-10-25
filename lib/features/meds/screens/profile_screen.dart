import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rkpm_5/features/meds/models/profile.dart';
import 'package:rkpm_5/features/meds/state/profile_storage.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});
  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  Profile? profile;

  @override
  void initState() {
    super.initState();
    nameCtrl = TextEditingController();
    ageCtrl = TextEditingController();
    _load();
  }

  Future<void> _load() async {
    final stored = await ProfileStorage.load();
    setState(() {
      profile = stored ?? Profile(name: '', age: 0, avatarUrl: null);
      nameCtrl.text = profile!.name;
      ageCtrl.text = profile!.age > 0 ? profile!.age.toString() : '';
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
  }

  Future<void> _changeAvatar() async {
    final url = await ImageService.instance.nextAvatarImage();
    final updated = Profile(
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      avatarUrl: url,
    );
    await ProfileStorage.save(updated);
    if (!mounted) return;
    setState(() => profile = updated);
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
    return Scaffold(
      appBar: AppBar(title: const Text('Профиль')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
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
                      errorWidget: (_, __, ___) => const Icon(Icons.person, size: 60),
                    )
                        : const Icon(Icons.person, size: 60),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 24),
            TextField(controller: nameCtrl, decoration: const InputDecoration(labelText: 'Имя')),
            const SizedBox(height: 12),
            TextField(
              controller: ageCtrl,
              decoration: const InputDecoration(labelText: 'Возраст'),
              keyboardType: TextInputType.number,
            ),
            const SizedBox(height: 24),
            FilledButton.icon(onPressed: _save, icon: const Icon(Icons.save), label: const Text('Сохранить')),
          ],
        ),
      ),
    );
  }
}