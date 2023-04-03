// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/repositories/auth_repository.dart';

part 'sign_up_state.dart';

class SignUpProvider with ChangeNotifier {
  final AuthRepository authRepository;
  SignUpProvider({
    required this.authRepository,
  });

  SignUpState _state = SignUpState.initial();
  SignUpState get state => _state;

  Future<void> signUp({
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      _state = _state.copyWith(status: SignUpStatus.submitting);
      notifyListeners();

      await authRepository.signUp(
        name: name,
        email: email,
        password: password,
      );
      _state = _state.copyWith(status: SignUpStatus.success);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(
        status: SignUpStatus.error,
        error: e,
      );
      notifyListeners();
      rethrow;
    }
  }
}
