// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart' show Equatable;
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/repositories/auth_repository.dart';

part 'sign_in_state.dart';

class SignInProvider with ChangeNotifier {
  final AuthRepository authRepository;
  SignInProvider({
    required this.authRepository,
  });

  SignInState _state = SignInState.initial();
  SignInState get state => _state;

  Future<void> signIn({
    required String email,
    required String password,
  }) async {
    try {
      _state = _state.copyWith(status: SignInStatus.submitting);
      notifyListeners();

      await authRepository.signIn(email: email, password: password);

      _state = _state.copyWith(status: SignInStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(
        status: SignInStatus.error,
        error: e,
      );
      notifyListeners();
      rethrow;
    }
  }
}
