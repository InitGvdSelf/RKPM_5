import 'package:flutter/material.dart';
import 'package:rkpm_5/core/theme_controller.dart';
import 'package:rkpm_5/features/profile/view/settings_view.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SettingsView(theme: ThemeController());
  }
}

