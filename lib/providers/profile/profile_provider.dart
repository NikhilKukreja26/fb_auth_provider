import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart' show ChangeNotifier;

import 'package:fb_auth_provider/models/custom_error.dart';
import 'package:fb_auth_provider/models/user_model.dart';
import 'package:fb_auth_provider/repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileProvider with ChangeNotifier {
  final ProfileRepository profileRepository;
  ProfileProvider({
    required this.profileRepository,
  });

  ProfileState _state = ProfileState.initial();
  ProfileState get state => _state;

  Future<void> getUserProfile({
    required String uid,
  }) async {
    try {
      _state = _state.copyWith(profileStatus: ProfileStatus.loading);
      notifyListeners();
      final User user = await profileRepository.getProfile(uid: uid);
      _state =
          _state.copyWith(profileStatus: ProfileStatus.success, user: user);
      notifyListeners();
    } on CustomError catch (e) {
      _state = _state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      );
      notifyListeners();
    }
  }
}
