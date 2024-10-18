import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/seller_repo.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:dartz/dartz.dart';

class GetSeller {
  final SellerRepository authRepository;

  GetSeller({required this.authRepository});

  Future<Either<Failure, SellerModel>> call(
      {required GetSellerParams params}) async {
    return await authRepository.getSeller(params: params);
  }
}
