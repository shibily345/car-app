import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:dio/dio.dart';

abstract class CarListRemoteDataSource {
  Future<dynamic> getCarList();
}

class CarListRemoteDataSourceImpl implements CarListRemoteDataSource {
  CarListRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<CarModel>> getCarList() async {
    final response = await dio.get(
      '${Ac.baseUrl}/api/car/get',
      queryParameters: {
        'api_key': 'if you need',
      },
    );

    if (response.statusCode == 200) {
      // Assuming response data is a list of cars
      return (response.data as List)
          .map((car) => CarModel.fromJson(car))
          .toList();
    } else {
      throw ServerException();
    }
  }
}
