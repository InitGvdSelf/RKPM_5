// lib/core/app_dependencies.dart
import 'package:flutter/widgets.dart';
import 'package:rkpm_5/features/meds/state/meds_state.dart';
import 'package:rkpm_5/features/meds/state/auth_service.dart';
import 'package:rkpm_5/features/meds/state/image_service.dart';

class AppDependencies extends InheritedWidget {
  final MedsState state;
  final AuthService auth;
  final ImageService images;

  const AppDependencies({
    super.key,
    required this.state,
    required this.auth,
    required this.images,
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
        !identical(old.auth, auth)   ||
        !identical(old.images, images);
  }
}