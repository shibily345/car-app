import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

abstract class SellerRemoteDataSource {
  Future<SellerModel> getSeller({required GetSellerParams params});
  Future<Response> updateSeller({required AddSellerParams params});
  Future<Response> editSeller({required AddSellerParams params});
  Future<List<SellerModel>> getAllSellers();
}

class SellerRemoteDataSourceImpl implements SellerRemoteDataSource {
  final Dio dio;

  SellerRemoteDataSourceImpl({required this.dio});

  @override
  Future<List<SellerModel>> getAllSellers() async {
    try {
      // Sending request to the server
      Response response = await dio.get(
        "${Ac.baseUrl}/api/seller/get",
      );

      // Check for 200 status code
      if (response.statusCode == 200) {
        debugPrint(
            "${response.data}*******************got it first all************************************");
        return (response.data as List)
            .map((car) => SellerModel.fromJson(car))
            .toList(); // Access 'data' from response JSON
      } else {
        debugPrint(
            "${response.statusCode}**********cant get all***************");

        throw ServerException(); // Throw a server exception if status is not 200
      }
    } catch (e) {
      debugPrint(
          "Error: ${e.toString()}************error on all seller***************************");

      throw ServerException(); // Handle any exceptions
    }
  }

  @override
  Future<SellerModel> getSeller({required GetSellerParams params}) async {
    try {
      // Sending request to the server
      Response response = await dio.get(
        "${Ac.baseUrl}/api/seller/currentSeller",
        data: {
          "uid": params.id,
        },
      );

      // Check for 200 status code
      if (response.statusCode == 200) {
        debugPrint(
            "${response.data}******************************************************************************");
        return SellerModel.fromJson(
            response.data['data']); // Access 'data' from response JSON
      } else {
        debugPrint(
            "${response.statusCode}******************************************************************************");

        throw ServerException(); // Throw a server exception if status is not 200
      }
    } catch (e) {
      debugPrint(
          "Error: ${e.toString()}******************************************************************************");

      throw ServerException(); // Handle any exceptions
    }
  }

  // Update seller information
  @override
  Future<Response> updateSeller({required AddSellerParams params}) async {
    try {
      final response = await dio.post(
        '${Ac.baseUrl}/api/seller/up',
        data: params.data.toJson(), // Ensure 'params.data.toJson()' is correct
      );
      debugPrint(
          "---response----${response.statusMessage}------------------------");
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      debugPrint("DioException: ${e.response?.data} - ${e.message}");
      return e.response ??
          Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500, // Return a default response if it's null
              statusMessage: 'Unknown error occurred');
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}------------------------");
      return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          statusMessage: 'Unknown error');
    }
  }

  @override
  Future<Response> editSeller({required AddSellerParams params}) async {
    try {
      final response = await dio.put(
        '${Ac.baseUrl}/api/seller/${params.data.id}',
        data: params.data.toJson(),
      );
      debugPrint(
          "---response----${response.statusMessage}------------------------");
      return response;
    } on DioException catch (e) {
      // Handle Dio-specific exceptions
      debugPrint("DioException: ${e.response?.data} - ${e.message}");
      return e.response ??
          Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 500, // Return a default response if it's null
              statusMessage: 'Unknown error occurred');
    } catch (e) {
      debugPrint("Unexpected error: ${e.toString()}------------------------");
      return Response(
          requestOptions: RequestOptions(path: ''),
          statusCode: 500,
          statusMessage: 'Unknown error');
    }
  }
}
