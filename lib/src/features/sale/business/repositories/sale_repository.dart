import '../entities/sale_entity.dart';
import 'package:car_app_beta/core/resources/data_state.dart';

abstract class SaleRepository {
  Future<DataState<SaleEntity>> createSale(SaleEntity sale);
  Future<DataState<List<SaleEntity>>> getAllSales();
  Future<DataState<SaleEntity>> getSaleById(String id);
  Future<DataState<SaleEntity>> updateSale(String id, SaleEntity sale);
  Future<DataState<void>> deleteSale(String id);
}
