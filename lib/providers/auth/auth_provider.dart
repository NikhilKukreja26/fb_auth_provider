// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart' show Equatable;
import 'package:firebase_auth/firebase_auth.dart' as fb_auth;
import 'package:flutter/foundation.dart' show ChangeNotifier, kDebugMode;

import 'package:fb_auth_provider/repositories/auth_repository.dart';

part 'auth_state.dart';

class AuthProvider with ChangeNotifier {
  final AuthRepository authRepository;
  AuthProvider({
    required this.authRepository,
  });

  AuthState _state = AuthState.unknown();

  AuthState get state => _state;

  void update(fb_auth.User? user) {
    if (user != null) {
      _state = _state.copyWith(
        status: AuthStatus.authenticated,
        user: user,
      );
    } else {
      _state = _state.copyWith(
        status: AuthStatus.unauthenticated,
        user: null,
      );
    }
    if (kDebugMode) {
      print('authStatus: $state');
    }
    notifyListeners();
  }

  Future<void> signOut() async {
    await authRepository.signOut();
  }
}
