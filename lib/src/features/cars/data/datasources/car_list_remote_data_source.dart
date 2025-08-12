import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:dio/dio.dart';

abstract class CarListRemoteDataSource {
  Future<List<CarModel>> getCarList();
}

class CarListRemoteDataSourceImpl implements CarListRemoteDataSource {
  CarListRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<List<CarModel>> getCarList() async {
    try {
      // Use the correct endpoint as per API documentation
      const endpoint = '${Ac.baseUrl}/api/car/get';

      const Map<String, String> headers = {
        'Content-Type': 'application/json',
      };

      print('Fetching car list from: $endpoint');
      final response = await dio.get(
        endpoint,
        options: Options(
          headers: headers,
          sendTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ),
      );

      print('Response status: ${response.statusCode}');
      print('Response data type: ${response.data.runtimeType}');

      // Handle successful response
      if (response.statusCode == 200) {
        if (response.data is Map<String, dynamic>) {
          final responseData = response.data as Map<String, dynamic>;

          // Check if response has the expected structure with status and data fields
          if (responseData['status'] == true && responseData['data'] != null) {
            final List<dynamic> carsData = responseData['data'];
            print('Received ${carsData.length} cars from API');

            return carsData
                .map((carJson) {
                  try {
                    return CarModel.fromJson(carJson);
                  } catch (e) {
                    print('Error parsing car: $e');
                    print('Car JSON: $carJson');
                    // Return null for invalid cars, will be filtered out
                    return null;
                  }
                })
                .where((car) => car != null)
                .cast<CarModel>()
                .toList();
          } else {
            print('API response status is false or data is null');
            print('Response: $responseData');
            throw ServerException();
          }
        } else {
          print(
              'Unexpected response format. Expected Map but got: ${response.data.runtimeType}');
          throw ServerException();
        }
      } else {
        print('API request failed with status: ${response.statusCode}');
        throw ServerException();
      }
    } on DioException catch (e) {
      print('DioException: ${e.response?.data} - ${e.message}');
      if (e.response?.statusCode == 404) {
        throw ServerException();
      } else if (e.response?.statusCode == 500) {
        throw ServerException();
      } else if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException();
      } else if (e.type == DioExceptionType.receiveTimeout) {
        throw ServerException();
      } else {
        throw ServerException();
      }
    } catch (e) {
      print('Unexpected error: $e');
      throw ServerException();
    }
  }
}
