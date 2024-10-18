import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/my_shop/business/repositories/car_list_repository.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

class PostCarData {
  PostCarData({required this.carDataRepository});
  final CarDataRepository carDataRepository;

  Future<Either<Failure, Response>> call(
      {required AddCarDataParams params}) async {
    return await carDataRepository.postCarData(params: params);
  }
}
