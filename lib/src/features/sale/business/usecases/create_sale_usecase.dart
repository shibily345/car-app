import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import '../entities/sale_entity.dart';
import '../repositories/sale_repository.dart';

class CreateSaleUseCase implements UseCase<DataState<SaleEntity>, SaleEntity> {
  final SaleRepository repository;
  CreateSaleUseCase(this.repository);

  @override
  Future<DataState<SaleEntity>> call({SaleEntity? params}) async {
    return await repository.createSale(params!);
  }
}
