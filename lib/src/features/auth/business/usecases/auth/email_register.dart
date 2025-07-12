import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/auth_repository.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:dartz/dartz.dart';

class RegisterWithEmail {
  final AuthRepository authRepository;

  RegisterWithEmail({required this.authRepository});

  Future<Either<Failure, UserModel>> call(String email, String password) async {
    return await authRepository.emailRegister(email, password);
  }
}
