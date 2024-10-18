import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/cars/business/entities/sub_entity.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:dartz/dartz.dart';

abstract class CarListRepository {
  Future<Either<Failure, List<CarModel>>> getCarList();
  Future<Either<Failure, ResponseEntity>> postCarData();
}
