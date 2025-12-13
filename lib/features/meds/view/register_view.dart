// lib/features/meds/view/register_view.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/features/meds/state/register/register_cubit.dart';
import 'package:rkpm_5/features/meds/state/register/register_state.dart';

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  final _formKey = GlobalKey<FormState>();
  final _nameCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  String? _validateName(String? v) {
    if ((v ?? '').trim().isEmpty) return 'Введите имя';
    return null;
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Введите email';
    if (!value.contains('@')) return 'Некорректный email';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.length < 4) return 'Минимум 4 символа';
    return null;
  }

  Future<void> _register(BuildContext context, RegisterCubit cubit) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final ok = await cubit.register(
      name: _nameCtrl.text.trim(),
      email: _emailCtrl.text.trim(),
      password: _passCtrl.text,
    );

    if (!mounted) return;

    if (ok) {
      context.go(Routes.main);
    } else if (cubit.state.errorMessage != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(cubit.state.errorMessage!)),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RegisterCubit, RegisterState>(
      builder: (context, state) {
        final cubit = context.read<RegisterCubit>();

        return Scaffold(
          appBar: AppBar(title: const Text('Регистрация')),
          body: Center(
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 420),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Form(
                  key: _formKey,
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      TextFormField(
                        controller: _nameCtrl,
                        decoration: const InputDecoration(
                          labelText: 'Имя',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateName,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _emailCtrl,
                        keyboardType: TextInputType.emailAddress,
                        decoration: const InputDecoration(
                          labelText: 'Email',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validateEmail,
                      ),
                      const SizedBox(height: 12),
                      TextFormField(
                        controller: _passCtrl,
                        obscureText: true,
                        decoration: const InputDecoration(
                          labelText: 'Пароль',
                          border: OutlineInputBorder(),
                        ),
                        validator: _validatePassword,
                      ),
                      const SizedBox(height: 16),
                      SizedBox(
                        width: double.infinity,
                        child: FilledButton(
                          onPressed: state.isSubmitting
                              ? null
                              : () => _register(context, cubit),
                          child: state.isSubmitting
                              ? const SizedBox(
                            height: 20,
                            width: 20,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                              : const Text('Создать аккаунт'),
                        ),
                      ),
                      const SizedBox(height: 8),
                      TextButton(
                        onPressed: () => context.go(Routes.authWithMode('login')),
                        child: const Text('Уже есть аккаунт? Войти'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}