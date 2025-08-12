import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class DeleteRentalUseCase implements UseCase<DataState<void>, String> {
  final RentalRepository repository;
  DeleteRentalUseCase(this.repository);

  @override
  Future<DataState<void>> call({String? params}) async {
    return await repository.deleteRental(params!);
  }
}
