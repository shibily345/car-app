import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class SellerRepository {
  Future<Either<Failure, Response>> updateSeller(
      {required AddSellerParams params});
  Future<Either<Failure, SellerModel>> getSeller(
      {required GetSellerParams params});
  Future<Either<Failure, Response>> editSeller(
      {required AddSellerParams params});
  Future<Either<Failure, List<SellerModel>>> getAllSeller();
}
