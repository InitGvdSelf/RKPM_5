import 'package:flutter/material.dart';

import '../../core/models/auth_data.dart';
import '../../data/datasources/local/secure_storage_datasource.dart';
import '../../domain/usecases/auth_usecase.dart';

class SecureStorageDemoScreen extends StatefulWidget {
  const SecureStorageDemoScreen({super.key});

  @override
  State<SecureStorageDemoScreen> createState() => _SecureStorageDemoScreenState();
}

class _SecureStorageDemoScreenState extends State<SecureStorageDemoScreen> {
  late final SecureStorageDataSource _ds;
  late final AuthUseCase _authUC;

  final _pinController = TextEditingController(text: '1234');
  String _log = '—';

  @override
  void initState() {
    super.initState();
    _ds = SecureStorageDataSource();
    _authUC = AuthUseCase(_ds);
  }

  @override
  void dispose() {
    _pinController.dispose();
    super.dispose();
  }

  Future<void> _saveTokens() async {
    await _authUC.saveAuthData(
      const AuthData(
        accessToken: 'access_token_demo_ABC',
        refreshToken: 'refresh_token_demo_XYZ',
        userId: '42',
      ),
    );
    setState(() => _log = 'Токены сохранены в Secure Storage');
  }

  Future<void> _readTokens() async {
    final data = await _authUC.getAuthData();
    setState(() {
      _log = data == null
          ? 'Токенов нет (или данные неполные)'
          : 'Прочитано:\naccess=${data.accessToken}\nrefresh=${data.refreshToken}\nuserId=${data.userId}';
    });
  }

  Future<void> _logout() async {
    await _authUC.logout();
    setState(() => _log = 'Logout: access/refresh удалены');
  }

  Future<void> _setBiometric(bool enabled) async {
    await _ds.setBiometricEnabled(enabled);
    final v = await _ds.isBiometricEnabled();
    setState(() => _log = 'Biometric enabled = $v');
  }

  Future<void> _savePin() async {
    await _ds.savePinCode(_pinController.text.trim());
    setState(() => _log = 'PIN сохранён');
  }

  Future<void> _verifyPin() async {
    final ok = await _ds.verifyPinCode(_pinController.text.trim());
    setState(() => _log = ok ? 'PIN верный ✅' : 'PIN неверный ❌');
  }

  Future<void> _readAll() async {
    final all = await _ds.getAllValues();
    setState(() => _log = 'readAll():\n${all.entries.map((e) => '${e.key}=${e.value}').join('\n')}');
  }

  Future<void> _clearAll() async {
    await _ds.clearAll();
    setState(() => _log = 'deleteAll(): всё очищено');
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(useMaterial3: true),
      home: Scaffold(
        appBar: AppBar(title: const Text('PR12 — Secure Storage Demo')),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              FilledButton(onPressed: _saveTokens, child: const Text('Save tokens')),
              const SizedBox(height: 8),
              FilledButton(onPressed: _readTokens, child: const Text('Read tokens')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _logout, child: const Text('Logout (delete tokens)')),
              const Divider(height: 24),

              TextField(
                controller: _pinController,
                decoration: const InputDecoration(labelText: 'PIN'),
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Expanded(
                    child: FilledButton(onPressed: _savePin, child: const Text('Save PIN')),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: FilledButton(onPressed: _verifyPin, child: const Text('Verify PIN')),
                  ),
                ],
              ),
              const Divider(height: 24),

              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _setBiometric(true),
                      child: const Text('Biometric ON'),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => _setBiometric(false),
                      child: const Text('Biometric OFF'),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),

              OutlinedButton(onPressed: _readAll, child: const Text('readAll()')),
              const SizedBox(height: 8),
              OutlinedButton(onPressed: _clearAll, child: const Text('deleteAll()')),
              const SizedBox(height: 16),

              const Text('Лог:'),
              const SizedBox(height: 8),
              Expanded(child: SingleChildScrollView(child: Text(_log))),
            ],
          ),
        ),
      ),
    );
  }
}