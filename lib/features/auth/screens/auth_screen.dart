import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app/app_router.dart';
import 'package:rkpm_5/features/auth/cubit/auth_cubit.dart';
import 'package:rkpm_5/features/auth/cubit/auth_state.dart';

class AuthScreen extends StatefulWidget {
  final String mode;

  const AuthScreen({super.key, required this.mode});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _nameCtrl.dispose();
    super.dispose();
  }

  String? _validateEmail(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Введите email';
    if (!value.contains('@')) return 'Некорректный email';
    return null;
  }

  String? _validatePassword(String? v) {
    final value = v ?? '';
    if (value.isEmpty) return 'Введите пароль';
    if (value.length < 4) return 'Минимум 4 символа';
    return null;
  }

  String? _validateName(String? v) {
    final value = (v ?? '').trim();
    if (value.isEmpty) return 'Введите имя';
    return null;
  }

  Future<void> _submit(BuildContext context, AuthCubit cubit) async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final isRegister = widget.mode == 'register';
    final ok = isRegister
        ? await cubit.signUp(
            name: _nameCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
          )
        : await cubit.signIn(
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
    return BlocProvider(
      create: (_) => AuthCubit(),
      child: BlocBuilder<AuthCubit, AuthState>(
        builder: (context, state) {
          final cubit = context.read<AuthCubit>();
          final isRegister = widget.mode == 'register';

          return Scaffold(
            appBar: AppBar(title: Text(isRegister ? 'Регистрация' : 'Вход')),
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
                        if (isRegister) ...[
                          TextFormField(
                            controller: _nameCtrl,
                            decoration: const InputDecoration(
                              labelText: 'Имя',
                              border: OutlineInputBorder(),
                            ),
                            validator: _validateName,
                          ),
                          const SizedBox(height: 12),
                        ],
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
                                : () => _submit(context, cubit),
                            child: state.isSubmitting
                                ? const SizedBox(
                                    height: 20,
                                    width: 20,
                                    child: CircularProgressIndicator(strokeWidth: 2),
                                  )
                                : Text(isRegister ? 'Зарегистрироваться' : 'Войти'),
                          ),
                        ),
                        const SizedBox(height: 8),
                        TextButton(
                          onPressed: () => context.go(
                            Routes.authWithMode(isRegister ? 'login' : 'register'),
                          ),
                          child: Text(
                            isRegister
                                ? 'Уже есть аккаунт? Войти'
                                : 'Нет аккаунта? Зарегистрироваться',
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

