import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

abstract class CarDataRepository {
  Future<Either<Failure, Response>> editCarData(
      {required UpdateCarParams params});
  Future<Either<Failure, Response>> postCarData(
      {required AddCarDataParams params});
  Future<Either<Failure, Response>> deleteCarData(
      {required DeleteCarParams params});
}
