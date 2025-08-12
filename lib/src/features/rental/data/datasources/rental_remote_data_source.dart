import 'package:dio/dio.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/src/features/rental/data/models/rental_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

abstract class RentalRemoteDataSource {
  Future<RentalModel> createRental(RentalModel rental);
  Future<List<RentalModel>> getAllRentals();
  Future<RentalModel> getRentalById(String id);
  Future<RentalModel> updateRental(String id, RentalModel rental);
  Future<void> deleteRental(String id);
  Future<List<RentalModel>> getSellerRentals(String sellerId);
  Future<Map<String, dynamic>> getSellerStatistics(String sellerId);
  Future<List<RentalModel>> getAvailableRentals({
    String? city,
    String? state,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
  });
  Future<Map<String, dynamic>> checkAvailability(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<Map<String, dynamic>> calculateCost(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
    String rentalType,
    Map<String, bool> additionalFeatures,
  );
  Future<RentalModel> updateRentalStatus(String id, String status);
  Future<List<RentalModel>> searchRentals({
    String? location,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
    List<String>? features,
    int? minAge,
    bool? instantBooking,
  });
}

class RentalRemoteDataSourceImpl implements RentalRemoteDataSource {
  final Dio dio;

  RentalRemoteDataSourceImpl(this.dio);

  @override
  Future<RentalModel> createRental(RentalModel rental) async {
    try {
      final rentalWithDefaults = RentalModel.withDefaults(
        id: rental.id,
        sellerId: rental.sellerId,
        carId: rental.carId,
        rentalType: rental.rentalType,
        pricing: rental.pricing as RentalPricingModel?,
        availability: rental.availability as RentalAvailabilityModel?,
        pickupLocation: rental.pickupLocation as RentalLocationModel?,
        returnLocation: rental.returnLocation as RentalLocationModel?,
        terms: rental.terms as RentalTermsModel?,
        rentalFeatures: rental.rentalFeatures as RentalFeaturesModel?,
        operatingHours: rental.operatingHours as RentalOperatingHoursModel?,
        status: rental.status,
        createdAt: rental.createdAt,
        updatedAt: rental.updatedAt,
      );
      final jsonPayload = jsonEncode(rentalWithDefaults.toJson());
      debugPrint('Rental POST payload: \n$jsonPayload');
      final response = await dio.post(
        '${Ac.baseUrl}/api/rental/create',
        data: rentalWithDefaults.toJson(),
      );
      debugPrint('>>>>rrrrrrrr>>>>>>>>>>>>>>: ${response.data}');
      if (response.data['status'] == true) {
        return RentalModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to create rental: $e');
    }
  }

  @override
  Future<List<RentalModel>> getAllRentals() async {
    try {
      final response = await dio.get('${Ac.baseUrl}/api/rental/get');
      print(response.statusCode);
      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RentalModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to get rentals: $e');
    }
  }

  @override
  Future<RentalModel> getRentalById(String id) async {
    try {
      final response = await dio.get('${Ac.baseUrl}/api/rental/get/$id');

      if (response.data['status'] == true) {
        return RentalModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to get rental: $e');
    }
  }

  @override
  Future<RentalModel> updateRental(String id, RentalModel rental) async {
    try {
      final rentalWithDefaults = RentalModel.withDefaults(
        id: rental.id,
        sellerId: rental.sellerId,
        carId: rental.carId,
        rentalType: rental.rentalType,
        pricing: rental.pricing as RentalPricingModel?,
        availability: rental.availability as RentalAvailabilityModel?,
        pickupLocation: rental.pickupLocation as RentalLocationModel?,
        returnLocation: rental.returnLocation as RentalLocationModel?,
        terms: rental.terms as RentalTermsModel?,
        rentalFeatures: rental.rentalFeatures as RentalFeaturesModel?,
        operatingHours: rental.operatingHours as RentalOperatingHoursModel?,
        status: rental.status,
        createdAt: rental.createdAt,
        updatedAt: rental.updatedAt,
      );
      debugPrint(
          'Rental PUT payload: \n${jsonEncode(rentalWithDefaults.toJson())}');
      final response = await dio.put(
        '${Ac.baseUrl}/api/rental/update/$id',
        data: rentalWithDefaults.toJson(),
      );

      if (response.data['status'] == true) {
        return RentalModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to update rental: $e');
    }
  }

  @override
  Future<void> deleteRental(String id) async {
    debugPrint(
        '[RentalRemoteDataSource] Attempting to delete rental with id: $id');
    try {
      final response = await dio.delete('${Ac.baseUrl}/api/rental/delete/$id');
      debugPrint(
          '[RentalRemoteDataSource] Delete response: \nStatus: ${response.statusCode}\nData: ${response.data}');
      if (response.data['status'] != true) {
        debugPrint(
            '[RentalRemoteDataSource] Delete failed: ${response.data['message']}');
        throw Exception(response.data['message']);
      } else {
        debugPrint('[RentalRemoteDataSource] Rental deleted successfully.');
      }
    } catch (e) {
      debugPrint('[RentalRemoteDataSource] Exception during delete: $e');
      throw Exception('Failed to delete rental: $e');
    }
  }

  @override
  Future<List<RentalModel>> getSellerRentals(String sellerId) async {
    try {
      final response =
          await dio.get('${Ac.baseUrl}/api/rental/seller/$sellerId');

      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RentalModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to get seller rentals: $e kooi');
    }
  }

  @override
  Future<Map<String, dynamic>> getSellerStatistics(String sellerId) async {
    try {
      final response =
          await dio.get('${Ac.baseUrl}/api/rental/seller/$sellerId/stats');

      if (response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to get seller statistics: $e');
    }
  }

  @override
  Future<List<RentalModel>> getAvailableRentals({
    String? city,
    String? state,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (city != null) queryParams['city'] = city;
      if (state != null) queryParams['state'] = state;
      if (rentalType != null) queryParams['rentalType'] = rentalType;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;

      final response = await dio.get(
        '${Ac.baseUrl}/api/rental/available',
        queryParameters: queryParams,
      );

      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RentalModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to get available rentals: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> checkAvailability(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final response = await dio.post(
        '${Ac.baseUrl}/api/rental/$rentalId/check-availability',
        data: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
        },
      );

      if (response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to check availability: $e');
    }
  }

  @override
  Future<Map<String, dynamic>> calculateCost(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
    String rentalType,
    Map<String, bool> additionalFeatures,
  ) async {
    try {
      final response = await dio.post(
        '${Ac.baseUrl}/api/rental/$rentalId/calculate-cost',
        data: {
          'startDate': startDate.toIso8601String(),
          'endDate': endDate.toIso8601String(),
          'rentalType': rentalType,
          'additionalFeatures': additionalFeatures,
        },
      );

      if (response.data['status'] == true) {
        return response.data['data'];
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to calculate cost: $e');
    }
  }

  @override
  Future<RentalModel> updateRentalStatus(String id, String status) async {
    try {
      final response = await dio.put(
        '${Ac.baseUrl}/api/rental/$id/status',
        data: {'status': status},
      );

      if (response.data['status'] == true) {
        return RentalModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to update rental status: $e');
    }
  }

  @override
  Future<List<RentalModel>> searchRentals({
    String? location,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
    List<String>? features,
    int? minAge,
    bool? instantBooking,
  }) async {
    try {
      final Map<String, dynamic> queryParams = {};
      if (location != null) queryParams['location'] = location;
      if (rentalType != null) queryParams['rentalType'] = rentalType;
      if (minPrice != null) queryParams['minPrice'] = minPrice;
      if (maxPrice != null) queryParams['maxPrice'] = maxPrice;
      if (features != null) queryParams['features'] = features.join(',');
      if (minAge != null) queryParams['minAge'] = minAge;
      if (instantBooking != null)
        queryParams['instantBooking'] = instantBooking;

      final response = await dio.get(
        '${Ac.baseUrl}/api/rental/search',
        queryParameters: queryParams,
      );

      if (response.data['status'] == true) {
        final List<dynamic> data = response.data['data'];
        return data.map((json) => RentalModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message']);
      }
    } catch (e) {
      throw Exception('Failed to search rentals: $e');
    }
  }
}
