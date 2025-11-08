// lib/features/meds/screens/login_screen.dart
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rkpm_5/app_router.dart';
import 'package:rkpm_5/core/app_dependencies.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});
  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _form = GlobalKey<FormState>();
  final _email = TextEditingController();
  final _pass  = TextEditingController();
  bool _loading = false;
  bool _obscure = true;

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    super.dispose();
  }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;

    setState(() => _loading = true);
    final auth = AppDependencies.of(context).auth; // <- через InheritedWidget
    await auth.signIn(email: _email.text.trim(), password: _pass.text);

    if (!mounted) return;
    setState(() => _loading = false);
    context.go(Routes.profile); // переход на профиль после логина
  }

  void _openRegister() => context.push('/register'); // если есть такой роут

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Вход')),
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
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (v) => (v == null || v.isEmpty)
                        ? 'Введите email'
                        : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pass,
                    obscureText: _obscure,
                    decoration: InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: const Icon(Icons.lock),
                      suffixIcon: IconButton(
                        icon: Icon(_obscure ? Icons.visibility : Icons.visibility_off),
                        onPressed: () => setState(() => _obscure = !_obscure),
                      ),
                    ),
                    validator: (v) =>
                    (v == null || v.length < 4) ? 'Минимум 4 символа' : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _loading ? null : _login,
                    icon: _loading
                        ? const SizedBox(
                      height: 18,
                      width: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                        : const Icon(Icons.login),
                    label: const Text('Войти'),
                  ),
                  const SizedBox(height: 12),
                  TextButton.icon(
                    onPressed: _openRegister,
                    icon: const Icon(Icons.person_add_alt_1),
                    label: const Text('Регистрация'),
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