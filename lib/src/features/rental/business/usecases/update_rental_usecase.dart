import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class UpdateRentalUseCase
    implements UseCase<DataState<RentalEntity>, UpdateRentalParams> {
  final RentalRepository repository;
  UpdateRentalUseCase(this.repository);

  @override
  Future<DataState<RentalEntity>> call({UpdateRentalParams? params}) async {
    return await repository.updateRental(params!.id, params.rental);
  }
}

class UpdateRentalParams {
  final String id;
  final RentalEntity rental;
  UpdateRentalParams({required this.id, required this.rental});
}
