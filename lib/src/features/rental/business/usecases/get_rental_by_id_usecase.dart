import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class GetRentalByIdUseCase implements UseCase<DataState<RentalEntity>, String> {
  final RentalRepository repository;
  GetRentalByIdUseCase(this.repository);

  @override
  Future<DataState<RentalEntity>> call({String? params}) async {
    return await repository.getRentalById(params!);
  }
}
