import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class GetAllRentalsUseCase
    implements UseCase<DataState<List<RentalEntity>>, void> {
  final RentalRepository repository;

  GetAllRentalsUseCase(this.repository);

  @override
  Future<DataState<List<RentalEntity>>> call({void params}) async {
    return await repository.getAllRentals();
  }
}
