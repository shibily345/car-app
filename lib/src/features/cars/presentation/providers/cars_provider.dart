import 'dart:io';

import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/business/usecases/get_car_list.dart';
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_local_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_remote_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/data/repositories/car_list_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../../../core/connection/network_info.dart';
import '../../../../../core/errors/failure.dart';

class CarsProvider extends ChangeNotifier {
  List<CarEntity>? cars;
  Failure? failure;
  bool _isLoaded = false;
  CarsProvider({
    this.cars,
    this.failure,
  });
  bool? get isloaded => _isLoaded;
  Future<Either<Failure, List<CarModel>>> eitherFailureOrCars() async {
    CarListRepositoryImpl repository = CarListRepositoryImpl(
      remoteDataSource: CarListRemoteDataSourceImpl(dio: Dio()),
      localDataSource: CarListLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrCars =
        await GetCarList(carListRepository: repository).call();

    failureOrCars.fold(
      (newFailure) {
        cars = null;
        failure = newFailure;
        debugPrint("----------------------------$newFailure");
        notifyListeners();
      },
      (newCars) {
        cars = newCars;
        // debugPrint("----------------------------$newCars");
        failure = null;
        _isLoaded = true;
        notifyListeners();
      },
    );
    return failureOrCars;
  }

  Future<void> uploadImage(File imageFile) async {
    String fileName = imageFile.path;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      Response response = await Dio().post(
        "http://your-server-ip:3000/upload", // Replace with your server IP
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print("Upload Response: ${response.data}");
    } catch (e) {
      print("Error: $e");
    }
  }
}
