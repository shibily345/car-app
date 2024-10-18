import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/my_shop/business/repositories/car_list_repository.dart';
import 'package:car_app_beta/src/features/my_shop/data/datasources/car_data_remote_data_source.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';

class CarDataRepositoryImpl implements CarDataRepository {
  CarDataRepositoryImpl({
    required this.remoteDataSource,
    required this.networkInfo,
  });
  final CarDataRemoteDataSource remoteDataSource;
  final NetworkInfo networkInfo;

  @override
  Future<Either<Failure, Response>> deleteCarData(
      {required DeleteCarParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final postResponse =
            await remoteDataSource.deleteCarData(params: params);

        // localDataSource.cacheCarData(postResponse);

        return Right(postResponse);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      throw NetworkInfo;
    }
  }

  @override
  Future<Either<Failure, Response>> editCarData(
      {required UpdateCarParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final postResponse = await remoteDataSource.editCarData(params: params);

        // localDataSource.cacheCarData(postResponse);

        return Right(postResponse);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      throw NetworkInfo;
    }
  }

  @override
  Future<Either<Failure, Response>> postCarData(
      {required AddCarDataParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final postResponse = await remoteDataSource.postCarData(params: params);

        // localDataSource.cacheCarData(postResponse);

        return Right(postResponse);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      throw NetworkInfo;
    }
  }
}
