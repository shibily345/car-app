import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    required String id,
    required String title,
    required String make,
    required String model,
    required int year,
    required String color,
    required double price,
    required int mileage,
    required String description,
    required List<String> features,
    required List<String> images,
    required String location,
    required String transmission,
    required String fuel,
    required String sellerId,
  }) : super(
          id: id,
          title: title,
          make: make,
          model: model,
          year: year,
          color: color,
          price: price,
          mileage: mileage,
          description: description,
          features: features,
          images: images,
          location: location,
          transmission: transmission,
          fuel: fuel,
          sellerId: sellerId,
        );

  factory CarModel.fromJson(Map<String, dynamic> json) {
    return CarModel(
      id: json['id'],
      title: json['title'],
      make: json['make'],
      model: json['model'],
      year: json['year'],
      color: json['color'],
      price: json['price'].toDouble(),
      mileage: json['mileage'],
      description: json['description'],
      features: List<String>.from(json['features']),
      images: List<String>.from(json['images']),
      location: json['location'],
      transmission: json['transmission'],
      fuel: json['fuel'],
      sellerId: json['sellerId'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'make': make,
      'model': model,
      'year': year,
      'color': color,
      'price': price,
      'mileage': mileage,
      'description': description,
      'features': features,
      'images': images,
      'location': location,
      'transmission': transmission,
      'fuel': fuel,
      'sellerId': sellerId,
    };
  }
}
