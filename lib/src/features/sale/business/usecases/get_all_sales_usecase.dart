import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GetAllSalesUseCase implements UseCase<DataState<List<SaleEntity>>, void> {
  final SaleRepository repository;
  GetAllSalesUseCase(this.repository);

  @override
  Future<DataState<List<SaleEntity>>> call({void params}) async {
    return await repository.getAllSales();
  }
}
