import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class UpdateSaleUseCase
    implements UseCase<DataState<SaleEntity>, UpdateSaleParams> {
  final SaleRepository repository;
  UpdateSaleUseCase(this.repository);

  @override
  Future<DataState<SaleEntity>> call({UpdateSaleParams? params}) async {
    return await repository.updateSale(params!.id, params.sale);
  }
}

class UpdateSaleParams {
  final String id;
  final SaleEntity sale;
  UpdateSaleParams({required this.id, required this.sale});
}
