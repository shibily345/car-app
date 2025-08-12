import 'package:dio/dio.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';
import 'package:car_app_beta/src/features/rental/data/datasources/rental_remote_data_source.dart';

class RentalRepositoryImpl implements RentalRepository {
  final RentalRemoteDataSource remoteDataSource;

  RentalRepositoryImpl(this.remoteDataSource);

  DioException _createDioException(String message) {
    return DioException(
      requestOptions: RequestOptions(path: ''),
      error: message,
    );
  }

  @override
  Future<DataState<RentalEntity>> createRental(RentalEntity rental) async {
    try {
      final rentalModel = rental as dynamic; // Cast to model
      final result = await remoteDataSource.createRental(rentalModel);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<List<RentalEntity>>> getAllRentals() async {
    try {
      final result = await remoteDataSource.getAllRentals();
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<RentalEntity>> getRentalById(String id) async {
    try {
      final result = await remoteDataSource.getRentalById(id);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<RentalEntity>> updateRental(
      String id, RentalEntity rental) async {
    try {
      final rentalModel = rental as dynamic; // Cast to model
      final result = await remoteDataSource.updateRental(id, rentalModel);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteRental(String id) async {
    try {
      await remoteDataSource.deleteRental(id);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<List<RentalEntity>>> getSellerRentals(
      String sellerId) async {
    try {
      final result = await remoteDataSource.getSellerRentals(sellerId);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> getSellerStatistics(
      String sellerId) async {
    try {
      final result = await remoteDataSource.getSellerStatistics(sellerId);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<List<RentalEntity>>> getAvailableRentals({
    String? city,
    String? state,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
  }) async {
    try {
      final result = await remoteDataSource.getAvailableRentals(
        city: city,
        state: state,
        rentalType: rentalType,
        minPrice: minPrice,
        maxPrice: maxPrice,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> checkAvailability(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
  ) async {
    try {
      final result = await remoteDataSource.checkAvailability(
        rentalId,
        startDate,
        endDate,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<Map<String, dynamic>>> calculateCost(
    String rentalId,
    DateTime startDate,
    DateTime endDate,
    String rentalType,
    Map<String, bool> additionalFeatures,
  ) async {
    try {
      final result = await remoteDataSource.calculateCost(
        rentalId,
        startDate,
        endDate,
        rentalType,
        additionalFeatures,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<RentalEntity>> updateRentalStatus(
      String id, String status) async {
    try {
      final result = await remoteDataSource.updateRentalStatus(id, status);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<List<RentalEntity>>> searchRentals({
    String? location,
    String? rentalType,
    double? minPrice,
    double? maxPrice,
    List<String>? features,
    int? minAge,
    bool? instantBooking,
  }) async {
    try {
      final result = await remoteDataSource.searchRentals(
        location: location,
        rentalType: rentalType,
        minPrice: minPrice,
        maxPrice: maxPrice,
        features: features,
        minAge: minAge,
        instantBooking: instantBooking,
      );
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }
}
