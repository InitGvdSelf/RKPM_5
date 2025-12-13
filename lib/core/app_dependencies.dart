// lib/core/app_dependencies.dart
import 'package:flutter/widgets.dart';
import 'package:rkpm_5/features/meds/domain/meds_state.dart';
import 'package:rkpm_5/features/meds/domain/auth_service.dart';
import 'package:rkpm_5/features/meds/domain/image_service.dart';
import 'package:rkpm_5/core/theme_controller.dart';

class AppDependencies extends InheritedWidget {
  final MedsState state;
  final AuthService auth;
  final ImageService images;
  final ThemeController theme;

  const AppDependencies({
    super.key,
    required this.state,
    required this.auth,
    required this.images,
    required this.theme,
    required Widget child,
  }) : super(child: child);

  static AppDependencies of(BuildContext context) {
    final deps = context.dependOnInheritedWidgetOfExactType<AppDependencies>();
    assert(deps != null, 'AppDependencies not found in widget tree');
    return deps!;
  }

  @override
  bool updateShouldNotify(covariant AppDependencies old) {
    return !identical(old.state, state) ||
        !identical(old.auth, auth) ||
        !identical(old.images, images) ||
        !identical(old.theme, theme);
  }
}