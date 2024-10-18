import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:dartz/dartz.dart';

abstract class AuthRepository {
  Future<Either<Failure, UserModel>> googleSignIn();
  Future<Either<Failure, UserModel>> appleSignIn();
}
