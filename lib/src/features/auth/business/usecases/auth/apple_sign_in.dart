import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/auth_repository.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:dartz/dartz.dart';

class AppleSignIn {
  final AuthRepository authRepository;

  AppleSignIn({required this.authRepository});

  Future<Either<Failure, UserModel>> call() async {
    return await authRepository.appleSignIn();
  }
}
