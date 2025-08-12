import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/cars/business/entities/sub_entity.dart';
import 'package:car_app_beta/src/features/cars/business/repositories/car_list_repository.dart';
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_local_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_remote_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:dartz/dartz.dart';

class CarListRepositoryImpl implements CarListRepository {
  CarListRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });
  final CarListRemoteDataSource remoteDataSource;
  final CarListLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, List<CarModel>>> getCarList() async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteCarList = await remoteDataSource.getCarList();

        await localDataSource.cacheCarList(
          carListToCache: remoteCarList,
        );

        return Right(remoteCarList);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      try {
        final localCarList = await localDataSource.getLastCarList();
        return Right(localCarList);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'This is a cache exception'));
      }
    }
  }

  @override
  Future<Either<Failure, ResponseEntity>> postCarData() {
    // TODO: implement postCarData
    throw UnimplementedError();
  }
}
