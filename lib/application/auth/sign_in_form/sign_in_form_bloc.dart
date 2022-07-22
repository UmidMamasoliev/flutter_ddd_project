// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:bloc/bloc.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_ddd_project/domain/auth/auth_failure.dart';
import 'package:flutter_ddd_project/domain/auth/i_auth_facade.dart';
import 'package:flutter_ddd_project/domain/auth/value_objects.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'sign_in_form_bloc.freezed.dart';
part 'sign_in_form_event.dart';
part 'sign_in_form_state.dart';

class SignInFormBloc extends Bloc<SignInFormEvent, SingInFormState> {
  final IAuthFacade _authFacade;

  SignInFormBloc(this._authFacade) : super(SingInFormState.initial()) {
    on<SignInFormEvent>(
      (event, emit) {
        event.map(
          emailChanged: (e) {
            emit(
              state.copyWith(
                emailAddress: EmailAddress(e.emailStr),
                authFailureOrSuccessOption: none(),
              ),
            );
          },
          passwordChanged: (e) {
            emit(
              state.copyWith(
                password: Password(e.passwordStr),
                authFailureOrSuccessOption: none(),
              ),
            );
          },
          registerWithEmailAndPasswordPressed: (e) async {
            _performActionOnAuthFacadeWithEmailAndPassword(
              event,
              emit,
              _authFacade.registerWithEmailAndPassword,
            );
          },
          signInWithEmailAndPasswordPressed: (e) async {
            _performActionOnAuthFacadeWithEmailAndPassword(
              event,
              emit,
              _authFacade.signInWithEmailAndPassword,
            );
          },
          signInWithGooglePressed: (e) async {
            emit(
              state.copyWith(
                isSubmitting: true,
                authFailureOrSuccessOption: none(),
              ),
            );
            final failureOrSuccess = await _authFacade.signInWithGoogle();
            emit(
              state.copyWith(
                isSubmitting: false,
                authFailureOrSuccessOption: some(failureOrSuccess),
              ),
            );
          },
        );
      },
    );
  }

  Stream<SingInFormState> _performActionOnAuthFacadeWithEmailAndPassword(
    SignInFormEvent event,
    Emitter emit,
    Future<Either<AuthFailure, Unit>> Function({
      required EmailAddress emailAddress,
      required Password password,
    })
        forwardedCall,
  ) async* {
    Either<AuthFailure, Unit>? failureOrSuccess;

    final isEmailValid = state.emailAddress.isValid();
    final isPasswordValid = state.password.isValid();

    if (isEmailValid && isPasswordValid) {
      emit(
        state.copyWith(
          isSubmitting: true,
          authFailureOrSuccessOption: none(),
        ),
      );
      failureOrSuccess = await forwardedCall(
        emailAddress: state.emailAddress,
        password: state.password,
      );
    }

    emit(
      state.copyWith(
        isSubmitting: false,
        showErrorMessages: true,
        authFailureOrSuccessOption: optionOf(failureOrSuccess),
      ),
    );
  }
}
