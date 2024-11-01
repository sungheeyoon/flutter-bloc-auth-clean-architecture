import 'package:flutter_auth_template/core/error/failures.dart';
import 'package:flutter_auth_template/features/auth/domain/entities/user.dart';
import 'package:fpdart/fpdart.dart';

abstract interface class AuthRepository {
  Future<Either<Failure, User>> signInWithEmail({
    required String email,
    required String password,
  });
  Future<Either<Failure, User>> signUpWithEmail({
    required String email,
    required String password,
    required String name,
  });
  Future<Either<Failure, Unit>> signOut();
}
