import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/seller_repo.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:dartz/dartz.dart';

class GetAllSellers {
  final SellerRepository authRepository;

  GetAllSellers({required this.authRepository});

  Future<Either<Failure, List<SellerModel>>> call() async {
    return await authRepository.getAllSeller();
  }
}
