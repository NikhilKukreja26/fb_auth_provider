// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_in_provider.dart';

enum SignInStatus {
  initial,
  submitting,
  success,
  error,
}

class SignInState extends Equatable {
  final SignInStatus status;
  final CustomError error;

  const SignInState({
    this.status = SignInStatus.initial,
    required this.error,
  });

  factory SignInState.initial() {
    return const SignInState(
      error: CustomError(),
    );
  }

  SignInState copyWith({
    SignInStatus? status,
    CustomError? error,
  }) {
    return SignInState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'SignInState(status: $status, error: $error)';

  @override
  List<Object?> get props => [
        status,
        error,
      ];
}
