import 'package:flutter/material.dart';

// state + infra
import 'package:rkpm_5/features/meds/state/meds_state.dart';

// экраны
import 'package:rkpm_5/features/meds/screens/profile_screen.dart';
import 'package:rkpm_5/features/meds/screens/today_screen.dart';
import 'package:rkpm_5/features/meds/screens/meds_list_screen.dart';
import 'package:rkpm_5/features/meds/screens/stats_screen.dart';
import 'package:rkpm_5/features/meds/screens/register_screen.dart';
// state + infra
import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/meds_repository.dart' as repo;
import 'package:rkpm_5/features/meds/state/dose_scheduler.dart' as sched;

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
  void dispose() { _email.dispose(); _pass.dispose(); super.dispose(); }

  Future<void> _login() async {
    if (!_form.currentState!.validate()) return;
    setState(() => _loading = true);

    final medsState = MedsState(
      repository: repo.MedsRepository(),
      scheduler:  sched.DoseScheduler(),
    );
    await medsState.init();

    if (!mounted) return;
    setState(() => _loading = false);

    final nav = Navigator.of(context);

    nav.pushReplacement(
      MaterialPageRoute(
        builder: (_) => ProfileScreen(
          onOpenToday: () {
            nav.push(MaterialPageRoute(
              builder: (_) => ScheduleScreen(
                medicines: medsState.medicines,
                dosesForDay: medsState.dosesForDay,
                onMarkDose: medsState.markDose,
                onSetDoseNote: medsState.setDoseNote,
                fmtDate: medsState.fmtDate,
                fmtMonth: medsState.fmtMonth,
                fmtTime: medsState.fmtTime,
              ),
            ));
          },
          onOpenMeds: () {
            nav.push(MaterialPageRoute(
              builder: (_) => MedsListScreen(
                medicines: medsState.medicines,
                onAddMedicine: medsState.addMedicine,
                onUpdateMedicine: medsState.updateMedicine,
                onDeleteMedicine: medsState.deleteMedicine,
                onRestoreMedicine: medsState.restoreMedicine,
              ),
            ));
          },
          onOpenStats: () {
            nav.push(MaterialPageRoute(
              builder: (_) => StatsScreen(
                medicines: medsState.medicines,
                doses: medsState.doses,
              ),
            ));
          },
        ),
      ),
    );
  }

  void _openRegister() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const RegisterScreen()),
    );
  }

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
                        labelText: 'Email', prefixIcon: Icon(Icons.mail)),
                    validator: (v) => (v==null||v.isEmpty) ? 'Введите email' : null,
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
                    validator: (v) => (v==null || v.length<4) ? 'Минимум 4 символа' : null,
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _loading ? null : _login,
                    icon: _loading
                        ? const SizedBox(height:18,width:18,child: CircularProgressIndicator(strokeWidth:2))
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