import 'package:dartz/dartz.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';

abstract class RentalRepository {
  Future<DataState<RentalEntity>> createRental(RentalEntity rental);
  Future<DataState<List<RentalEntity>>> getAllRentals();
  Future<DataState<RentalEntity>> getRentalById(String id);
  Future<DataState<RentalEntity>> updateRental(String id, RentalEntity rental);
  Future<DataState<void>> deleteRental(String id);
  Future<DataState<List<RentalEntity>>> getSellerRentals(String sellerId);
  Future<DataState<Map<String, dynamic>>> getSellerStatistics(String sellerId);
  Future<DataState<List<RentalEntity>>> getAvailableRentals({
    String? city,
    String? state,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
  });
  Future<DataState<Map<String, dynamic>>> checkAvailability(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
  );
  Future<DataState<Map<String, dynamic>>> calculateCost(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
    String rentalType,
    Map<String, bool> additionalFeatures,
  );
  Future<DataState<RentalEntity>> updateRentalStatus(String id, String status);
  Future<DataState<List<RentalEntity>>> searchRentals({
    String? location,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
    List<String>? features,
    int? minAge,
    bool? instantBooking,
  });
}
