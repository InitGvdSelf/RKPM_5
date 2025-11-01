import 'package:flutter/foundation.dart';

@immutable
class UserAccount {
  final String email;
  final String? name;

  const UserAccount({required this.email, this.name});
}