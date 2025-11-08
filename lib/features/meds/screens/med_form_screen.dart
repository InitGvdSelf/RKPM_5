// lib/features/meds/screens/med_form_screen.dart
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/core/app_dependencies.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart'; // для типа
import 'package:rkpm_5/features/meds/models/medicine.dart';

class MedFormScreen extends StatefulWidget {
  final Medicine? existing;

  const MedFormScreen({super.key, this.existing});

  @override
  State<MedFormScreen> createState() => _MedFormScreenState();
}

class _MedFormScreenState extends State<MedFormScreen> {
  final _formKey = GlobalKey<FormState>();

  late final TextEditingController nameCtrl;
  late final TextEditingController formCtrl;
  late final TextEditingController doseCtrl;
  late final TextEditingController notesCtrl;
  late final TextEditingController imageUrlCtrl;

  late Schedule _schedule;

  // зависимости из провайдера
  late ImageService _images;
  bool _imagesPrefetched = false;

  @override
  void initState() {
    super.initState();

    nameCtrl = TextEditingController(text: widget.existing?.name ?? '');
    formCtrl = TextEditingController(text: widget.existing?.form ?? '');
    doseCtrl = TextEditingController(text: widget.existing?.dose ?? '');
    notesCtrl = TextEditingController(text: widget.existing?.notes ?? '');
    imageUrlCtrl = TextEditingController(text: widget.existing?.imageUrl ?? '');

    _schedule = widget.existing?.schedule ??
        Schedule.weekly(
          active: true,
          daysOfWeek: {1, 2, 3, 4, 5, 6, 7}, // каждый день недели
          times: const [Clock(9, 0)],
        );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // получаем через InheritedWidget
    _images = AppDependencies.of(context).images;
    if (!_imagesPrefetched) {
      _images.prefetchAll();
      _imagesPrefetched = true;
    }
  }

  @override
  void dispose() {
    nameCtrl.dispose();
    formCtrl.dispose();
    doseCtrl.dispose();
    notesCtrl.dispose();
    imageUrlCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    // спрячем клавиатуру
    FocusScope.of(context).unfocus();

    String? url;
    final trimmed = imageUrlCtrl.text.trim();
    if (trimmed.isNotEmpty) {
      url = trimmed;
    } else {
      url = await _images.nextMedImage(); // <- берём из провайдера
    }

    if (widget.existing == null) {
      final med = Medicine(
        id: const Uuid().v4(),
        name: nameCtrl.text.trim(),
        form: formCtrl.text.trim(),
        dose: doseCtrl.text.trim(),
        notes: notesCtrl.text.trim(),
        imageUrl: url,
        schedule: _schedule,
      );
      if (!mounted) return;
      context.pop(med);
    } else {
      final m = widget.existing!;
      m
        ..name = nameCtrl.text.trim()
        ..form = formCtrl.text.trim()
        ..dose = doseCtrl.text.trim()
        ..notes = notesCtrl.text.trim()
        ..imageUrl = url
        ..schedule = _schedule;
      if (!mounted) return;
      context.pop(m);
    }
  }

  Widget _buildPreview() {
    final u = imageUrlCtrl.text.trim();
    if (u.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.only(top: 12),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: CachedNetworkImage(
          imageUrl: u,
          height: 160,
          width: double.infinity,
          fit: BoxFit.cover,
          placeholder: (_, __) => const SizedBox(
            height: 48,
            width: 48,
            child: Center(
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
          ),
          errorWidget: (_, __, ___) => Container(
            height: 160,
            color: Colors.black12,
            alignment: Alignment.center,
            child: const Icon(Icons.broken_image, size: 40),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isEdit = widget.existing != null;

    return Scaffold(
      appBar: AppBar(
        title: Text(isEdit ? 'Редактировать лекарство' : 'Добавить лекарство'),
        actions: [
          IconButton(
            onPressed: _save,
            icon: const Icon(Icons.check),
            tooltip: 'Сохранить',
          ),
        ],
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              TextFormField(
                controller: nameCtrl,
                decoration: const InputDecoration(
                  labelText: 'Название',
                ),
                validator: (v) =>
                (v == null || v.trim().isEmpty) ? 'Укажи название' : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: formCtrl,
                decoration: const InputDecoration(
                  labelText: 'Форма',
                  hintText: 'таблетки / капсулы / капли',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: doseCtrl,
                decoration: const InputDecoration(
                  labelText: 'Доза',
                  hintText: 'например, 500 мг',
                ),
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: notesCtrl,
                decoration: const InputDecoration(
                  labelText: 'Примечания',
                ),
                maxLines: 3,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: imageUrlCtrl,
                decoration: const InputDecoration(
                  labelText: 'URL изображения (необязательно)',
                  hintText: 'https://...',
                ),
                onChanged: (_) => setState(() {}), // обновляем превью
              ),
              _buildPreview(),
              const SizedBox(height: 24),
              FilledButton.icon(
                onPressed: _save,
                icon: const Icon(Icons.check),
                label: Text(isEdit ? 'Сохранить' : 'Добавить'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}