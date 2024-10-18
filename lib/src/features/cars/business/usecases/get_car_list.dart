import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/cars/business/repositories/car_list_repository.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:dartz/dartz.dart';

class GetCarList {
  GetCarList({required this.carListRepository});
  final CarListRepository carListRepository;

  Future<Either<Failure, List<CarModel>>> call() async {
    return await carListRepository.getCarList();
  }
}
