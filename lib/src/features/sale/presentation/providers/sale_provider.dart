import 'package:flutter/material.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:dio/dio.dart';
import '../../business/entities/sale_entity.dart';
import '../../business/usecases/create_sale_usecase.dart';
import '../../business/usecases/get_all_sales_usecase.dart';
import '../../business/usecases/get_sale_by_id_usecase.dart';
import '../../business/usecases/update_sale_usecase.dart';
import '../../business/usecases/delete_sale_usecase.dart';

class SaleProvider extends ChangeNotifier {
  final CreateSaleUseCase createSaleUseCase;
  final GetAllSalesUseCase getAllSalesUseCase;
  final GetSaleByIdUseCase getSaleByIdUseCase;
  final UpdateSaleUseCase updateSaleUseCase;
  final DeleteSaleUseCase deleteSaleUseCase;

  SaleProvider({
    required this.createSaleUseCase,
    required this.getAllSalesUseCase,
    required this.getSaleByIdUseCase,
    required this.updateSaleUseCase,
    required this.deleteSaleUseCase,
  });

  DataState<SaleEntity>? _createSaleState;
  DataState<List<SaleEntity>>? _allSalesState;
  DataState<SaleEntity>? _saleByIdState;
  DataState<SaleEntity>? _updateSaleState;
  DataState<void>? _deleteSaleState;
  bool _isLoading = false;
  String? _errorMessage;

  DataState<SaleEntity>? get createSaleState => _createSaleState;
  DataState<List<SaleEntity>>? get allSalesState => _allSalesState;
  DataState<SaleEntity>? get saleByIdState => _saleByIdState;
  DataState<SaleEntity>? get updateSaleState => _updateSaleState;
  DataState<void>? get deleteSaleState => _deleteSaleState;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  void _setLoading(bool value) {
    debugPrint('SaleProvider: Setting loading to $value');
    _isLoading = value;
    notifyListeners();
  }

  void _setError(String? message) {
    debugPrint('SaleProvider: Setting error to $message');
    _errorMessage = message;
    notifyListeners();
  }

  void _clearError() {
    debugPrint('SaleProvider: Clearing error');
    _errorMessage = null;
    notifyListeners();
  }

  Future<void> createSale(SaleEntity sale) async {
    debugPrint('SaleProvider: Creating sale for car ${sale.carId}');
    _setLoading(true);
    _clearError();
    _createSaleState = await createSaleUseCase(params: sale);

    if (_createSaleState is DataSuccess) {
      debugPrint('SaleProvider: Sale created successfully');
      _setError(null);
    } else if (_createSaleState is DataFailed) {
      debugPrint(
          'SaleProvider: Sale creation failed - ${_createSaleState!.error}');
      _setError(_createSaleState!.error.toString());
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> getAllSales() async {
    debugPrint('SaleProvider: Getting all sales');
    _setLoading(true);
    _clearError();
    _allSalesState = await getAllSalesUseCase();

    if (_allSalesState is DataSuccess) {
      debugPrint('SaleProvider: Got ${_allSalesState!.data!.length} sales');
      _setError(null);
    } else if (_allSalesState is DataFailed) {
      debugPrint(
          'SaleProvider: Get all sales failed - ${_allSalesState!.error}');
      _setError(_allSalesState!.error.toString());
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> getSaleById(String id) async {
    debugPrint('SaleProvider: Getting sale by ID $id');
    _setLoading(true);
    _clearError();
    _saleByIdState = await getSaleByIdUseCase(params: id);

    if (_saleByIdState is DataSuccess) {
      debugPrint('SaleProvider: Got sale by ID successfully');
      _setError(null);
    } else if (_saleByIdState is DataFailed) {
      debugPrint(
          'SaleProvider: Get sale by ID failed - ${_saleByIdState!.error}');
      _setError(_saleByIdState!.error.toString());
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> updateSale(String id, SaleEntity sale) async {
    debugPrint('SaleProvider: Updating sale $id');
    debugPrint(
        'SaleProvider: Sale data - CarId: ${sale.carId}, Price: ${sale.price}, Status: ${sale.status}');
    _setLoading(true);
    _clearError();

    try {
      _updateSaleState =
          await updateSaleUseCase(params: UpdateSaleParams(id: id, sale: sale));

      if (_updateSaleState is DataSuccess) {
        debugPrint('SaleProvider: Sale updated successfully');
        _setError(null);
      } else if (_updateSaleState is DataFailed) {
        debugPrint(
            'SaleProvider: Sale update failed - ${_updateSaleState!.error}');
        _setError(_updateSaleState!.error.toString());
      } else {
        debugPrint(
            'SaleProvider: Unexpected update state: ${_updateSaleState.runtimeType}');
        _setError('Unexpected response from server');
      }
    } catch (e) {
      debugPrint('SaleProvider: Exception during sale update: $e');
      _setError('Failed to update sale: $e');
      _updateSaleState = DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      ));
    }

    _setLoading(false);
    notifyListeners();
  }

  Future<void> deleteSale(String id) async {
    debugPrint('SaleProvider: Deleting sale $id');
    _setLoading(true);
    _clearError();

    try {
      _deleteSaleState = await deleteSaleUseCase(params: id);

      if (_deleteSaleState is DataSuccess) {
        debugPrint('SaleProvider: Sale deleted successfully');
        _setError(null);
      } else if (_deleteSaleState is DataFailed) {
        debugPrint(
            'SaleProvider: Sale deletion failed - ${_deleteSaleState!.error}');
        _setError(_deleteSaleState!.error.toString());
      } else {
        debugPrint(
            'SaleProvider: Unexpected delete state: ${_deleteSaleState.runtimeType}');
        _setError('Unexpected response from server');
      }
    } catch (e) {
      debugPrint('SaleProvider: Exception during sale deletion: $e');
      _setError('Failed to delete sale: $e');
      _deleteSaleState = DataFailed(DioException(
        requestOptions: RequestOptions(path: ''),
        error: e.toString(),
      ));
    }

    _setLoading(false);
    notifyListeners();
  }

  void clearStates() {
    debugPrint('SaleProvider: Clearing all states');
    _createSaleState = null;
    _allSalesState = null;
    _saleByIdState = null;
    _updateSaleState = null;
    _deleteSaleState = null;
    _errorMessage = null;
    notifyListeners();
  }

  // Get sales by seller ID
  Future<void> getSellerSales(String sellerId) async {
    debugPrint('SaleProvider: Getting sales for seller $sellerId');
    _setLoading(true);
    _clearError();
    _allSalesState = await getAllSalesUseCase();

    if (_allSalesState is DataSuccess) {
      // Filter sales by seller ID
      final sellerSales = _allSalesState!.data!
          .where((sale) => sale.sellerId == sellerId)
          .toList();
      debugPrint(
          'SaleProvider: Found ${sellerSales.length} sales for seller $sellerId');
      _setError(null);
    } else if (_allSalesState is DataFailed) {
      debugPrint(
          'SaleProvider: Get seller sales failed - ${_allSalesState!.error}');
      _setError(_allSalesState!.error.toString());
    }

    _setLoading(false);
    notifyListeners();
  }

  // Get sale by car ID
  SaleEntity? getSaleByCarId(String carId) {
    if (_allSalesState is DataSuccess && _allSalesState!.data != null) {
      try {
        return _allSalesState!.data!.firstWhere((sale) => sale.carId == carId);
      } catch (e) {
        debugPrint('SaleProvider: No sale found for carId: $carId');
        return null;
      }
    }
    return null;
  }
}
