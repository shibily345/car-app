import 'package:car_app_beta/core/usecase/usecase.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';

class GetSellerRentalsUseCase
    implements UseCase<DataState<List<RentalEntity>>, String> {
  final RentalRepository repository;

  GetSellerRentalsUseCase(this.repository);

  @override
  Future<DataState<List<RentalEntity>>> call({String? params}) async {
    return await repository.getSellerRentals(params!);
  }
}
