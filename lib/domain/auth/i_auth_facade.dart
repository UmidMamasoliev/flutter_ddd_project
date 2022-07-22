import 'package:dartz/dartz.dart';
import 'package:flutter_ddd_project/domain/auth/auth_failure.dart';

import 'value_objects.dart';

// Unit is just an empty tuple
// and it is very similar to void in Swift
// which is an empty tuple too "()"
abstract class IAuthFacade {
  Future<Either<AuthFailure, Unit>> registerWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithEmailAndPassword({
    required EmailAddress emailAddress,
    required Password password,
  });
  Future<Either<AuthFailure, Unit>> signInWithGoogle();
}
