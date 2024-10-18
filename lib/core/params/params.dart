import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';

class NoParams {}

class TemplateParams {}

class CarListParams {}

class AddSellerParams {
  final SellerModel data;

  AddSellerParams({required this.data});
}

class AddCarDataParams {
  final CarModel data;

  AddCarDataParams({required this.data});
}

class UpdateCarParams {
  final String id;
  final CarModel data;

  UpdateCarParams({required this.data, required this.id});
}

class DeleteCarParams {
  final String id;

  DeleteCarParams({required this.id});
}

class GetSellerParams {
  final String id;

  GetSellerParams({required this.id});
}

class PokemonParams {
  final String id;
  const PokemonParams({
    required this.id,
  });
}
