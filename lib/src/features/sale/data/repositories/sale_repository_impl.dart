import '../../business/entities/sale_entity.dart';
import '../../business/repositories/sale_repository.dart';
import '../datasources/sale_remote_data_source.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:dio/dio.dart';

class SaleRepositoryImpl implements SaleRepository {
  final SaleRemoteDataSource remoteDataSource;
  SaleRepositoryImpl(this.remoteDataSource);

  DioException _createDioException(String message) {
    return DioException(
        requestOptions: RequestOptions(path: ''), error: message);
  }

  @override
  Future<DataState<SaleEntity>> createSale(SaleEntity sale) async {
    try {
      final result = await remoteDataSource.createSale(sale as dynamic);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<List<SaleEntity>>> getAllSales() async {
    try {
      final result = await remoteDataSource.getAllSales();
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<SaleEntity>> getSaleById(String id) async {
    try {
      final result = await remoteDataSource.getSaleById(id);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<SaleEntity>> updateSale(String id, SaleEntity sale) async {
    try {
      final result = await remoteDataSource.updateSale(id, sale as dynamic);
      return DataSuccess(result);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }

  @override
  Future<DataState<void>> deleteSale(String id) async {
    try {
      await remoteDataSource.deleteSale(id);
      return const DataSuccess(null);
    } catch (e) {
      return DataFailed(_createDioException(e.toString()));
    }
  }
}
