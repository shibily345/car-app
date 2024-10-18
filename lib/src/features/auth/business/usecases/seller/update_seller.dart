import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/seller_repo.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class AddSeller {
  final SellerRepository authRepository;

  AddSeller({required this.authRepository});

  Future<Either<Failure, Response>> call(
      {required AddSellerParams params}) async {
    return await authRepository.updateSeller(params: params);
  }
}
