import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:rkpm_5/features/meds/state/form/form_cubit.dart';
import 'package:rkpm_5/features/meds/state/form/form_state.dart';

class MedFormView extends StatefulWidget {
  const MedFormView({super.key});

  @override
  State<MedFormView> createState() => _MedFormViewState();
}

class _MedFormViewState extends State<MedFormView> {
  final _nameCtrl = TextEditingController();
  final _formCtrl = TextEditingController();
  final _doseCtrl = TextEditingController();
  final _notesCtrl = TextEditingController();

  bool _initedFromState = false;

  @override
  void dispose() {
    _nameCtrl.dispose();
    _formCtrl.dispose();
    _doseCtrl.dispose();
    _notesCtrl.dispose();
    super.dispose();
  }

  Future<void> _onSave(MedFormCubit cubit, MedFormState state) async {
    final med = await cubit.submit();
    if (!mounted) return;

    if (med != null) {
      Navigator.of(context).pop(med);
    } else if (cubit.state.error != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cubit.state.error!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<MedFormCubit, MedFormState>(
      builder: (context, state) {
        final cubit = context.read<MedFormCubit>();

        if (!_initedFromState) {
          _initedFromState = true;
          _nameCtrl.text = state.name;
          _formCtrl.text = state.form;
          _doseCtrl.text = state.dose;
          _notesCtrl.text = state.notes;
        }

        final isEdit = state.isEdit;

        return Scaffold(
          appBar: AppBar(
            title:
            Text(isEdit ? 'Редактирование лекарства' : 'Новое лекарство'),
          ),
          body: SafeArea(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                TextFormField(
                  controller: _nameCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Название',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.updateName,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _formCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Форма (таблетки, капсулы...)',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.updateForm,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _doseCtrl,
                  decoration: const InputDecoration(
                    labelText: 'Дозировка',
                    border: OutlineInputBorder(),
                  ),
                  textInputAction: TextInputAction.next,
                  onChanged: cubit.updateDose,
                ),
                const SizedBox(height: 12),
                TextFormField(
                  controller: _notesCtrl,
                  maxLines: 3,
                  decoration: const InputDecoration(
                    labelText: 'Заметки',
                    border: OutlineInputBorder(),
                  ),
                  onChanged: cubit.updateNotes,
                ),
                const SizedBox(height: 20),
                Text(
                  'Изображение',
                  style: theme.textTheme.titleMedium,
                ),
                const SizedBox(height: 8),
                Center(
                  child: Column(
                    children: [
                      SizedBox(
                        width: 160,
                        height: 160,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(16),
                          child: state.imageUrl != null
                              ? CachedNetworkImage(
                            imageUrl: state.imageUrl!,
                            fit: BoxFit.cover,
                            placeholder: (context, _) =>
                            const Center(
                                child: CircularProgressIndicator(
                                    strokeWidth: 2)),
                            errorWidget: (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 48),
                          )
                              : Container(
                            color: Colors.grey.shade200,
                            child:
                            const Icon(Icons.image, size: 48),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton.icon(
                        onPressed: state.isSaving
                            ? null
                            : () => cubit.changeImage(),
                        icon: const Icon(Icons.refresh),
                        label: const Text('Сменить картинку'),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                if (state.error != null) ...[
                  Text(
                    state.error!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.error,
                    ),
                  ),
                  const SizedBox(height: 8),
                ],
                FilledButton.icon(
                  onPressed: state.isSaving
                      ? null
                      : () => _onSave(cubit, state),
                  icon: state.isSaving
                      ? const SizedBox(
                    height: 18,
                    width: 18,
                    child: CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Icon(Icons.check),
                  label: Text(isEdit ? 'Сохранить' : 'Добавить'),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}