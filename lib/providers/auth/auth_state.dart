// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'auth_provider.dart';

enum AuthStatus {
  unknown,
  authenticated,
  unauthenticated,
}

class AuthState extends Equatable {
  final AuthStatus status;
  final fb_auth.User? user;

  const AuthState({
    required this.status,
    this.user,
  });

  factory AuthState.unknown() {
    return const AuthState(status: AuthStatus.unknown);
  }

  AuthState copyWith({
    AuthStatus? status,
    fb_auth.User? user,
  }) {
    return AuthState(
      status: status ?? this.status,
      user: user ?? this.user,
    );
  }

  @override
  String toString() => 'AuthState(status: $status, user: $user)';

  @override
  List<Object?> get props => [status, user];
}
