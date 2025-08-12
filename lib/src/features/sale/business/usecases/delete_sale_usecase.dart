import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import '../repositories/sale_repository.dart';

class DeleteSaleUseCase implements UseCase<DataState<void>, String> {
  final SaleRepository repository;
  DeleteSaleUseCase(this.repository);

  @override
  Future<DataState<void>> call({String? params}) async {
    return await repository.deleteSale(params!);
  }
}
