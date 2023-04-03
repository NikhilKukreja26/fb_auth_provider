// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'sign_up_provider.dart';

enum SignUpStatus {
  initial,
  submitting,
  success,
  error,
}

class SignUpState extends Equatable {
  final SignUpStatus status;
  final CustomError error;

  const SignUpState({
    this.status = SignUpStatus.initial,
    required this.error,
  });

  factory SignUpState.initial() {
    return const SignUpState(
      error: CustomError(),
    );
  }

  SignUpState copyWith({
    SignUpStatus? status,
    CustomError? error,
  }) {
    return SignUpState(
      status: status ?? this.status,
      error: error ?? this.error,
    );
  }

  @override
  String toString() => 'SignUpState(status: $status, error: $error)';

  @override
  List<Object?> get props => [
        status,
        error,
      ];
}
