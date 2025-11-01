import 'package:flutter/material.dart';
import 'package:rkpm_5/features/meds/screens/profile_screen.dart'; // +++

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

  @override
  void dispose() {
    _email.dispose();
    _pass.dispose();
    _name.dispose();
    super.dispose();
  }

  Future<void> _register() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);
    await Future.delayed(const Duration(milliseconds: 500)); // имитация
    if (!mounted) return;
    setState(() => _loading = false);

    // Горизонтально (замена экрана, назад вернуться нельзя):
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (_) => const ProfileScreen()), // !!!
    );
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
                    decoration: const InputDecoration(
                      labelText: 'Имя',
                      prefixIcon: Icon(Icons.person),
                    ),
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Введите имя' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _email,
                    keyboardType: TextInputType.emailAddress,
                    decoration: const InputDecoration(
                      labelText: 'Email',
                      prefixIcon: Icon(Icons.mail),
                    ),
                    validator: (v) =>
                    (v == null || v.isEmpty) ? 'Введите email' : null,
                  ),
                  const SizedBox(height: 12),
                  TextFormField(
                    controller: _pass,
                    obscureText: true,
                    decoration: const InputDecoration(
                      labelText: 'Пароль',
                      prefixIcon: Icon(Icons.lock),
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