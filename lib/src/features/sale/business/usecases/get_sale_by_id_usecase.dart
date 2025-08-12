import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class GetSaleByIdUseCase implements UseCase<DataState<SaleEntity>, String> {
  final SaleRepository repository;
  GetSaleByIdUseCase(this.repository);

  @override
  Future<DataState<SaleEntity>> call({String? params}) async {
    return await repository.getSaleById(params!);
  }
}
