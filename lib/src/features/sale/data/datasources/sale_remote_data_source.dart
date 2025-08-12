import 'package:dio/dio.dart';
import '../models/sale_model.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

abstract class SaleRemoteDataSource {
  Future<SaleModel> createSale(SaleModel sale);
  Future<List<SaleModel>> getAllSales();
  Future<SaleModel> getSaleById(String id);
  Future<SaleModel> updateSale(String id, SaleModel sale);
  Future<void> deleteSale(String id);
}

class SaleRemoteDataSourceImpl implements SaleRemoteDataSource {
  final Dio dio;
  SaleRemoteDataSourceImpl(this.dio);

  @override
  Future<SaleModel> createSale(SaleModel sale) async {
    try {
      final jsonPayload = jsonEncode(sale.toJson());
      debugPrint('Sale POST payload: \n$jsonPayload');
      debugPrint('Sale POST URL: ${Ac.baseUrl}/api/sale/');

      // Debug the raw toJson result
      final rawJson = sale.toJson();
      debugPrint('SaleRemoteDataSource: Raw toJson result: $rawJson');
      debugPrint(
          'SaleRemoteDataSource: Raw toJson keys: ${rawJson.keys.toList()}');

      final response = await dio.post(
        '${Ac.baseUrl}/api/sale/',
        data: sale.toJson(),
      );

      debugPrint('Sale POST response status: ${response.statusCode}');
      debugPrint('Sale POST response data: ${response.data}');

      // Handle both 200 and 201 as success
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == true) {
          return SaleModel.fromJson(response.data['data']);
        } else if (response.data['data'] != null) {
          // Direct data response without status wrapper
          return SaleModel.fromJson(response.data['data']);
        } else {
          // Direct response without data wrapper
          return SaleModel.fromJson(response.data);
        }
      } else {
        throw Exception(response.data['message'] ?? 'Failed to create sale');
      }
    } catch (e) {
      debugPrint('Sale POST error: $e');
      throw Exception('Failed to create sale: $e');
    }
  }

  @override
  Future<List<SaleModel>> getAllSales() async {
    try {
      debugPrint('Sale GET ALL URL: ${Ac.baseUrl}/api/sale/');

      final response = await dio.get('${Ac.baseUrl}/api/sale/');

      debugPrint('Sale GET ALL response status: ${response.statusCode}');
      debugPrint('Sale GET ALL response data: ${response.data}');
      debugPrint(
          'Sale GET ALL response data type: ${response.data.runtimeType}');

      if (response.statusCode == 200 || response.statusCode == 201) {
        List<dynamic> data;

        // Handle different response structures
        if (response.data is List) {
          // Direct array response (current API structure)
          data = response.data;
        } else if (response.data['status'] == true &&
            response.data['data'] != null) {
          // Wrapped response structure
          data = response.data['data'];
        } else if (response.data['data'] is List) {
          // Alternative wrapped structure
          data = response.data['data'];
        } else {
          debugPrint(
              'Sale GET ALL: Unexpected response structure: ${response.data}');
          return [];
        }

        debugPrint('Sale GET ALL: Parsing ${data.length} sales');
        return data.map((json) => SaleModel.fromJson(json)).toList();
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get sales');
      }
    } catch (e) {
      debugPrint('Sale GET ALL error: $e');
      throw Exception('Failed to get sales: $e');
    }
  }

  @override
  Future<SaleModel> getSaleById(String id) async {
    try {
      debugPrint('Sale GET BY ID URL: ${Ac.baseUrl}/api/sale/get/$id');

      final response = await dio.get('${Ac.baseUrl}/api/sale/$id');

      debugPrint('Sale GET BY ID response status: ${response.statusCode}');
      debugPrint('Sale GET BY ID response data: ${response.data}');

      if (response.data['status'] == true) {
        return SaleModel.fromJson(response.data['data']);
      } else {
        throw Exception(response.data['message'] ?? 'Failed to get sale');
      }
    } catch (e) {
      debugPrint('Sale GET BY ID error: $e');
      throw Exception('Failed to get sale: $e');
    }
  }

  @override
  Future<SaleModel> updateSale(String id, SaleModel sale) async {
    try {
      final saleJson = sale.toJson();
      final jsonPayload = jsonEncode(saleJson);
      debugPrint('Sale PUT payload: \n$jsonPayload');
      debugPrint('Sale PUT URL: ${Ac.baseUrl}/api/sale/$id');
      debugPrint('Sale PUT sale ID: $id');
      debugPrint('Sale PUT sale model ID: ${sale.id}');
      debugPrint('Sale PUT sale JSON keys: ${saleJson.keys.toList()}');

      // Create a minimal update payload with only essential fields
      final minimalPayload = {
        'price': sale.price,
        'isAvailable': sale.isAvailable,
        'status': sale.status,
        'description': sale.description,
      };
      debugPrint('Sale PUT minimal payload: $minimalPayload');

      // Check if the API expects a different endpoint structure
      final updateUrl = '${Ac.baseUrl}/api/sale/update/$id';
      debugPrint('Sale PUT alternative URL: $updateUrl');

      Response response;
      try {
        // Try minimal payload first (only essential fields)
        debugPrint('Sale PUT trying minimal payload...');
        response = await dio.put(
          '${Ac.baseUrl}/api/sale/$id',
          data: minimalPayload,
        );
        debugPrint(
            'Sale PUT with minimal payload successful: ${response.statusCode}');
      } catch (minimalError) {
        debugPrint('Sale PUT with minimal payload failed: $minimalError');
        try {
          // Try full payload
          debugPrint('Sale PUT trying full payload...');
          response = await dio.put(
            '${Ac.baseUrl}/api/sale/$id',
            data: saleJson,
          );
          debugPrint(
              'Sale PUT with full payload successful: ${response.statusCode}');
        } catch (putError) {
          debugPrint('Sale PUT failed, trying PATCH: $putError');
          // Try PATCH as fallback
          response = await dio.patch(
            '${Ac.baseUrl}/api/sale/$id',
            data: saleJson,
          );
          debugPrint(
              'Sale PATCH successful with status: ${response.statusCode}');
        }
      }

      debugPrint('Sale PUT response status: ${response.statusCode}');
      debugPrint('Sale PUT response data: ${response.data}');

      // Handle different response structures
      if (response.statusCode == 200 || response.statusCode == 201) {
        if (response.data['status'] == true && response.data['data'] != null) {
          // Success with status wrapper
          return SaleModel.fromJson(response.data['data']);
        } else if (response.data['data'] != null) {
          // Direct data response without status wrapper
          return SaleModel.fromJson(response.data['data']);
        } else {
          // Direct response without data wrapper
          return SaleModel.fromJson(response.data);
        }
      } else if (response.data != null && response.data['message'] != null) {
        // Error with message
        throw Exception(response.data['message']);
      } else {
        // Generic error
        throw Exception('Failed to update sale: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sale PUT error: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          throw Exception('Sale not found');
        } else if (e.response?.statusCode == 403) {
          throw Exception('You do not have permission to update this sale');
        } else if (e.response?.statusCode == 400) {
          throw Exception('Invalid data provided for sale update');
        } else if (e.response?.statusCode == 500) {
          throw Exception('Server error occurred while updating sale');
        } else {
          throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Failed to update sale: $e');
    }
  }

  @override
  Future<void> deleteSale(String id) async {
    try {
      debugPrint('Sale DELETE URL: ${Ac.baseUrl}/api/sale/$id');

      final response = await dio.delete('${Ac.baseUrl}/api/sale/$id');

      debugPrint('Sale DELETE response status: ${response.statusCode}');
      debugPrint('Sale DELETE response data: ${response.data}');

      // Handle different response structures
      if (response.statusCode == 200 || response.statusCode == 204) {
        // Success - no content expected for DELETE
        return;
      } else if (response.data != null && response.data['status'] == true) {
        // Success with status wrapper
        return;
      } else if (response.data != null && response.data['message'] != null) {
        // Error with message
        throw Exception(response.data['message']);
      } else {
        // Generic error
        throw Exception('Failed to delete sale: HTTP ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Sale DELETE error: $e');
      if (e is DioException) {
        if (e.response?.statusCode == 404) {
          throw Exception('Sale not found');
        } else if (e.response?.statusCode == 403) {
          throw Exception('You do not have permission to delete this sale');
        } else if (e.response?.statusCode == 500) {
          throw Exception('Server error occurred while deleting sale');
        } else {
          throw Exception('Network error: ${e.message}');
        }
      }
      throw Exception('Failed to delete sale: $e');
    }
  }
}
