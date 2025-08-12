import 'package:dartz/dartz.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class CreateRentalUseCase
    implements UseCase<DataState<RentalEntity>, RentalEntity> {
  final RentalRepository repository;

  CreateRentalUseCase(this.repository);

  @override
  Future<DataState<RentalEntity>> call({RentalEntity? params}) async {
    return await repository.createRental(params!);
  }
}
