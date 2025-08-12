import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/seller_repo.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_local_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_remote_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:dartz/dartz.dart';
import 'package:dio/src/response.dart';
import 'package:flutter/foundation.dart';

class SellerRepositoryImpl implements SellerRepository {
  final SellerRemoteDataSource remoteDataSource;
  final SellerLocalDataSource localDataSource;
  final NetworkInfo networkInfo;

  SellerRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
    required this.networkInfo,
  });

  @override
  Future<Either<Failure, List<SellerModel>>> getAllSeller() async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteAllSellers = await remoteDataSource.getAllSellers();

        // localDataSource.cacheSeller(remoteSeller);

        return Right(remoteAllSellers);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      // try {
      //   final localSeller = await localDataSource.getAll();
      //   return Right(localSeller);
      // } on CacheException {
      return Left(CacheFailure(errorMessage: 'No local data found'));
      // }
    }
  }

  @override
  Future<Either<Failure, SellerModel>> getSeller(
      {required GetSellerParams params}) async {
    if (await networkInfo.isConnected!) {
      try {
        final remoteSeller = await remoteDataSource.getSeller(params: params);

        localDataSource.cacheSeller(remoteSeller);

        return Right(remoteSeller);
      } on ServerException {
        return Left(ServerFailure(errorMessage: 'This is a server exception'));
      }
    } else {
      try {
        final localSeller = await localDataSource.getLastSeller();
        return Right(localSeller);
      } on CacheException {
        return Left(CacheFailure(errorMessage: 'No local data found'));
      }
    }
  }

  @override
  Future<Either<Failure, Response>> updateSeller(
      {required AddSellerParams params}) async {
    try {
      debugPrint("Repository: Starting seller update");
      Response remoteSeller =
          await remoteDataSource.updateSeller(params: params);

      debugPrint(
          "Repository: Seller update response - ${remoteSeller.statusCode} - ${remoteSeller.statusMessage}");
      debugPrint("Repository: Response data - ${remoteSeller.data}");

      // localDataSource.cacheSeller(
      //     authToCache: UserModel.fromFirebaseUser(remoteSeller.user!));

      return Right(remoteSeller);
    } on ServerException catch (e) {
      debugPrint("Repository: ServerException caught - $e");
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    } catch (e) {
      debugPrint("Repository: Unexpected error - $e");
      return Left(ServerFailure(errorMessage: 'Unexpected error: $e'));
    }
  }

  @override
  Future<Either<Failure, Response>> editSeller(
      {required AddSellerParams params}) async {
    try {
      Response remoteSeller = await remoteDataSource.editSeller(params: params);

      // localDataSource.cacheSeller(
      //     authToCache: UserModel.fromFirebaseUser(remoteSeller.user!));

      return Right(remoteSeller);
    } on ServerException {
      return Left(ServerFailure(errorMessage: 'This is a server exception'));
    }
  }
}
