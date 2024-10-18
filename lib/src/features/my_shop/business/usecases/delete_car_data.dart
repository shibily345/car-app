import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/my_shop/business/repositories/car_list_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class DeleteCarData {
  DeleteCarData({required this.carDataRepository});
  final CarDataRepository carDataRepository;

  Future<Either<Failure, Response>> call(
      {required DeleteCarParams params}) async {
    return await carDataRepository.deleteCarData(params: params);
  }
}
