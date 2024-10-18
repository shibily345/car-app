import 'dart:convert';

import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class CarListLocalDataSource {
  Future<void> cacheCarList({required List<CarModel>? carListToCache});
  Future<dynamic> getLastCarList();
}

const cachedCarList = 'carList';

class CarListLocalDataSourceImpl implements CarListLocalDataSource {
  CarListLocalDataSourceImpl({required this.sharedPreferences});
  final SharedPreferences sharedPreferences;

  @override
  Future<dynamic> getLastCarList() {
    final jsonString = sharedPreferences.getString(cachedCarList);

    if (jsonString != null) {
      return Future.value(List<CarModel>);
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void> cacheCarList({required List<CarModel>? carListToCache}) async {
    if (carListToCache != null) {
      await sharedPreferences.setString(
        cachedCarList,
        json.encode(
          carListToCache,
        ),
      );
    } else {
      throw CacheException();
    }
  }
}
