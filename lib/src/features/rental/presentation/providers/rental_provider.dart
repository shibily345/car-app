import 'package:flutter/material.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/create_rental_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/get_seller_rentals_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/get_all_rentals_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/get_rental_by_id_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/delete_rental_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/update_rental_usecase.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:provider/provider.dart';
import 'package:dio/dio.dart';

class RentalProvider extends ChangeNotifier {
  final CreateRentalUseCase createRentalUseCase;
  final GetSellerRentalsUseCase getSellerRentalsUseCase;
  final GetAllRentalsUseCase getAllRentalsUseCase;
  final GetRentalByIdUseCase? getRentalByIdUseCase;
  final DeleteRentalUseCase? deleteRentalUseCase;
  final UpdateRentalUseCase? updateRentalUseCase;

  RentalProvider({
    required this.createRentalUseCase,
    required this.getSellerRentalsUseCase,
    required this.getAllRentalsUseCase,
    this.getRentalByIdUseCase,
    this.deleteRentalUseCase,
    this.updateRentalUseCase,
  });

  // State variables
  DataState<RentalEntity>? _createRentalState;
  DataState<List<RentalEntity>>? _sellerRentalsState;
  DataState<List<RentalEntity>>? _allRentalsState;
  bool _isLoading = false;
  bool _isAllRentalsLoading = false;
  String? _errorMessage;
  String? _allRentalsError;

  // Getters
  DataState<RentalEntity>? get createRentalState => _createRentalState;
  DataState<List<RentalEntity>>? get sellerRentalsState => _sellerRentalsState;
  DataState<List<RentalEntity>>? get allRentalsState => _allRentalsState;
  bool get isLoading => _isLoading;
  bool get isAllRentalsLoading => _isAllRentalsLoading;
  String? get errorMessage => _errorMessage;
  String? get allRentalsError => _allRentalsError;

  // Create rental
  Future<void> createRental(RentalEntity rental) async {
    _setLoading(true);
    _clearError();

    try {
      final result = await createRentalUseCase(params: rental);
      _createRentalState = result;
      debugPrint('createRentalState: ${rental.toString()}');
      if (result is DataSuccess) {
        // Refresh seller rentals after successful creation
        await getSellerRentals(rental.sellerId);
      } else if (result is DataFailed) {
        debugPrint('*****************: ${result.error}');
        _setError(result.error?.message ?? 'Failed to create rental');
      }
    } catch (e) {
      _setError(e.toString());
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Get seller rentals
  Future<void> getSellerRentals(String sellerId) async {
    debugPrint('getSellerRentals called with sellerId: $sellerId');
    _setLoading(true);
    _clearError();

    try {
      final result = await getSellerRentalsUseCase(params: sellerId);
      _sellerRentalsState = result;
      debugPrint('getSellerRentals result: $result');

      if (result is DataFailed) {
        _setError(result.error?.message ?? 'Failed to get seller rentals');
        debugPrint('getSellerRentals failed: ${result.error?.message}');
      } else if (result is DataSuccess) {
        debugPrint(
            'getSellerRentals success: ${result.data?.length ?? 0} rentals');
      }
    } catch (e) {
      _setError(e.toString());
      debugPrint('getSellerRentals exception: $e');
    } finally {
      _setLoading(false);
      notifyListeners();
    }
  }

  // Fetch all rentals
  Future<void> getAllRentals() async {
    _isAllRentalsLoading = true;
    _allRentalsError = null;
    notifyListeners();
    try {
      final result = await getAllRentalsUseCase();
      _allRentalsState = result;
      if (result is DataFailed) {
        _allRentalsError = result.error?.message ?? 'Failed to get rentals';
      }
    } catch (e) {
      _allRentalsError = e.toString();
    } finally {
      _isAllRentalsLoading = false;
      notifyListeners();
    }
  }

  Future<RentalEntity?> getRentalById(String rentalId) async {
    if (getRentalByIdUseCase == null) return null;
    final result = await getRentalByIdUseCase!(params: rentalId);
    if (result is DataSuccess) {
      return result.data;
    }
    return null;
  }

  RentalEntity? getRentalByCarId(String carId) {
    debugPrint('getRentalByCarId called with carId: $carId');
    debugPrint('sellerRentalsState type: ${sellerRentalsState.runtimeType}');

    // Check if sellerRentalsState is a success state and has data
    if (sellerRentalsState is DataSuccess) {
      final rentals = sellerRentalsState!.data;
      debugPrint('Found ${rentals?.length ?? 0} rentals');
      if (rentals != null) {
        try {
          final rental = rentals.firstWhere((rental) => rental.carId == carId);
          debugPrint('Found rental: ${rental.id}');
          return rental;
        } catch (_) {
          debugPrint('No rental found for carId: $carId');
          return null;
        }
      }
    } else {
      debugPrint('sellerRentalsState is not DataSuccess: $sellerRentalsState');
    }
    return null;
  }

  Future<DataState<void>?> deleteRental(
      String rentalId, BuildContext context) async {
    if (deleteRentalUseCase == null) {
      _setError(
          'Delete functionality is not available. Please restart the app.');
      notifyListeners();
      return DataFailed(
        DioException(
          requestOptions: RequestOptions(path: ''),
          error: 'DeleteRentalUseCase not available',
          type: DioExceptionType.unknown,
        ),
      );
    }
    _setLoading(true);
    _clearError();
    notifyListeners();
    DataState<void>? result;
    try {
      result = await deleteRentalUseCase!(params: rentalId);
      if (result is DataFailed) {
        debugPrint(
            '[RentalProvider] Delete failed: \\${result.error?.message}');
        _setError(result.error?.message ?? 'Failed to delete rental');
      } else {
        debugPrint('[RentalProvider] Rental deleted successfully.');
        // Refresh car data after delete
        await context.read<CarsProvider>().eitherFailureOrCars();
      }
    } catch (e) {
      debugPrint('[RentalProvider] Exception during delete: $e');
      _setError(e.toString());
    } finally {
      _setLoading(false);
      notifyListeners();
    }
    return result;
  }

  Future<DataState<RentalEntity>?> updateRental(
      String id, RentalEntity rental, BuildContext context) async {
    if (updateRentalUseCase == null) return null;
    final result = await updateRentalUseCase!(
        params: UpdateRentalParams(id: id, rental: rental));
    // Refresh car data after update
    await context.read<CarsProvider>().eitherFailureOrCars();
    notifyListeners();
    return result;
  }

  // Helper methods
  void _setLoading(bool loading) {
    _isLoading = loading;
  }

  void _setError(String message) {
    _errorMessage = message;
  }

  void _clearError() {
    _errorMessage = null;
  }

  void clearCreateRentalState() {
    _createRentalState = null;
    notifyListeners();
  }

  void clearError() {
    _clearError();
    notifyListeners();
  }

  void clearSellerRentalsState() {
    _sellerRentalsState = null;
    notifyListeners();
  }
}
