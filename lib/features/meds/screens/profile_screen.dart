import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart';
import 'package:rkpm_5/features/meds/state/profile_storage.dart';
import 'package:rkpm_5/features/meds/models/profile.dart';
import 'package:uuid/uuid.dart';

class ProfileScreen extends StatefulWidget {
  final bool embedded;
  const ProfileScreen({super.key, this.embedded = false});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final nameCtrl = TextEditingController();
  final ageCtrl = TextEditingController();
  String? avatarUrl;
  String? profileId;
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final p = await ProfileStorage.load();
    nameCtrl.text = p?.name?.trim() ?? '';
    ageCtrl.text = (p?.age ?? 0) == 0 ? '' : '${p!.age}';
    avatarUrl = p?.avatarUrl;
    profileId = p?.id ?? const Uuid().v4();
    setState(() => loading = false);
  }

  Future<void> _changeAvatar() async {
    final url = await ImageService.instance.nextAvatarImage();
    setState(() => avatarUrl = url);
  }

  Future<void> _save() async {
    final p = Profile(
      id: profileId ?? const Uuid().v4(),
      name: nameCtrl.text.trim(),
      age: int.tryParse(ageCtrl.text.trim()) ?? 0,
      avatarUrl: avatarUrl,
    );
    await ProfileStorage.save(p);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Профиль сохранён')),
    );
  }

  @override
  Widget build(BuildContext context) {
    if (loading) {
      return Scaffold(
        appBar: widget.embedded ? null : AppBar(title: const Text('Профиль')),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      appBar: widget.embedded ? null : AppBar(title: const Text('Профиль')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          if (!widget.embedded)
            const Padding(
              padding: EdgeInsets.only(bottom: 12),
              child: Text(
                'Профиль',
                style: TextStyle(fontSize: 28, fontWeight: FontWeight.w700),
              ),
            ),
          Center(
            child: Stack(
              alignment: Alignment.bottomRight,
              children: [
                ClipOval(
                  child: SizedBox(
                    width: 140,
                    height: 140,
                    child: avatarUrl == null
                        ? Container(color: Colors.black12)
                        : CachedNetworkImage(
                      imageUrl: avatarUrl!,
                      fit: BoxFit.cover,
                      placeholder: (_, __) =>
                      const Center(child: CircularProgressIndicator()),
                      errorWidget: (_, __, ___) => const ColoredBox(
                        color: Colors.black12,
                        child: Icon(Icons.broken_image, size: 40),
                      ),
                    ),
                  ),
                ),
                Material(
                  shape: const CircleBorder(),
                  color: Theme.of(context).colorScheme.primary,
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: _changeAvatar,
                    child: const Padding(
                      padding: EdgeInsets.all(10),
                      child: Icon(Icons.camera_alt, color: Colors.white),
                    ),
                  ),
                ),
              ],
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
          const SizedBox(height: 24),
          FilledButton.icon(
            onPressed: _save,
            icon: const Icon(Icons.save),
            label: const Text('Сохранить'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    super.dispose();
  }
}