import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class CarDataRemoteDataSource {
  Future<Response> postCarData({required AddCarDataParams params});
  Future<Response> editCarData({required UpdateCarParams params});
  Future<Response> deleteCarData({required DeleteCarParams params});
}

class CarDataRemoteDataSourceImpl implements CarDataRemoteDataSource {
  CarDataRemoteDataSourceImpl({required this.dio});
  final Dio dio;

  @override
  Future<Response> deleteCarData({required DeleteCarParams params}) async {
    try {
      final response = await dio.delete(
        '${Ac.baseUrl}/api/car/${params.id}',
        // data: params,
      );
      debugPrint(
          "---response----${response.statusMessage}------------------------");
      return response;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.response?.data} - ${e.message}");
      return e.response!;
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}------------------------");
      return Response(requestOptions: RequestOptions(baseUrl: ""));
    }
  }

  @override
  Future<Response> editCarData({required UpdateCarParams params}) async {
    try {
      debugPrint("params: ${params.data.toJson()}");
      final response = await dio.put(
        '${Ac.baseUrl}/api/car/${params.id}',
        data: params.data.toJson(),
      );
      debugPrint(
          "---response----${response.statusMessage}------------------------");
      return response;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.response?.data} - ${e.message}");
      return e.response!;
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}------------------------");
      return Response(requestOptions: RequestOptions(baseUrl: ""));
    }
  }

  @override
  Future<Response> postCarData({required AddCarDataParams params}) async {
    try {
      final response = await dio.post(
        '${Ac.baseUrl}/api/car/up',
        data: params.data.toJson(),
      );
      debugPrint(
          "---response----${response.statusMessage}------------------------");
      return response;
    } on DioException catch (e) {
      debugPrint("DioException: ${e.response?.data} - ${e.message}");
      return e.response!;
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}------------------------");
      return Response(requestOptions: RequestOptions(baseUrl: ""));
    }
  }
}
