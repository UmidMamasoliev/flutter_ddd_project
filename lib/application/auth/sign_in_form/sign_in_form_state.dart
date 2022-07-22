part of 'sign_in_form_bloc.dart';

@freezed
abstract class SingInFormState with _$SingInFormState {
  const factory SingInFormState({
    required EmailAddress emailAddress,
    required Password password,
    required bool showErrorMessages,
    required bool isSubmitting,
    required Option<Either<AuthFailure, Unit>> authFailureOrSuccessOption,
  }) = _SingInFormState;

  factory SingInFormState.initial() => SingInFormState(
        emailAddress: EmailAddress(''),
        password: Password(''),
        showErrorMessages: false,
        isSubmitting: false,
        authFailureOrSuccessOption: none(),
      );
}
