// lib/features/meds/screens/register_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  final _name  = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (_loading) return; // защита от повторных тапов
    if (!_form.currentState!.validate()) return;

    setState(() => _loading = true);
    final auth = AppDependencies.of(context).auth; // <- через InheritedWidget
    await auth.signUp(
      name: _name.text.trim(),
      email: _email.text.trim(),
      password: _pass.text,
    );

    if (!mounted) return;
    setState(() => _loading = false);
    context.go(Routes.profile); // после регистрации — на профиль
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Регистрация')),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _form,
              child: ListView(
                children: [
                  TextFormField(
                    controller: _name,
                    textInputAction: TextInputAction.next,
                    textCapitalization: TextCapitalization.words,
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    textInputAction: TextInputAction.next,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (v) =>
                    (v == null || v.trim().isEmpty) ? 'Введите email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pass,
                    obscureText: _obscure,
                    textInputAction: TextInputAction.done,
                    onFieldSubmitted: (_) => _register(),
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        onPressed: () => setState(() => _obscure = !_obscure),
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                      ),
                    ),
                    validator: (v) =>
                    (v == null || v.length < 4) ? 'Минимум 4 символа' : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _loading ? null : _register,
                    icon: _loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.check),
                    label: const Text('Создать аккаунт'),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}