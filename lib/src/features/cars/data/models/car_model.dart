import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';

class CarModel extends CarEntity {
  const CarModel({
    super.id,
    super.title,
    super.make,
    super.model,
    super.year,
    super.color,
    super.price,
    super.mileage,
    super.description,
    super.features,
    super.images,
    super.location,
    super.transmission,
    super.fuel,
    super.sellerId,
    super.createdAt,
    super.updatedAt,
    super.type,
    super.seats,
    super.isVerified = false,
    super.isForSale = false,
    super.isForRent = false,
  });

  factory CarModel.fromJson(Map<String, dynamic> json) {
    try {
      return CarModel(
        id: json['_id']?.toString(),
        title: json['title']?.toString(),
        make: json['make']?.toString(),
        model: json['model']?.toString(),
        year: json['year'] is int
            ? json['year']
            : int.tryParse(json['year']?.toString() ?? ''),
        color: json['color']?.toString(),
        price: json['price'] != null
            ? (json['price'] is double
                ? json['price']
                : double.tryParse(json['price'].toString()))
            : null,
        mileage: json['mileage'] is int
            ? json['mileage']
            : int.tryParse(json['mileage']?.toString() ?? ''),
        description: json['description']?.toString(),
        features: json['features'] != null
            ? List<String>.from(json['features'])
            : null,
        images:
            json['images'] != null ? List<String>.from(json['images']) : null,
        location: json['location']?.toString(),
        transmission: json['transmission']?.toString(),
        fuel: json['fuel']?.toString(),
        sellerId: json['sellerId']?.toString(),
        createdAt: json['createdAt'] != null
            ? DateTime.tryParse(json['createdAt'].toString())
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.tryParse(json['updatedAt'].toString())
            : null,
        type: json['type']?.toString(),
        seats: json['seats']?.toString(),
        isVerified: json['isVerified'] ?? false,
        isForSale: json['isForSale'] ?? false,
        isForRent: json['isForRent'] ?? false,
      );
    } catch (e) {
      print('Error parsing CarModel from JSON: $e');
      print('JSON data: $json');
      rethrow;
    }
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
      'type': type,
      'seats': seats,
      'isVerified': isVerified,
      'isForSale': isForSale,
      'isForRent': isForRent,
    };
  }

  CarModel copyWith({
    String? id,
    String? title,
    String? make,
    String? model,
    int? year,
    String? color,
    double? price,
    int? mileage,
    String? description,
    List<String>? features,
    List<String>? images,
    String? location,
    String? transmission,
    String? fuel,
    String? sellerId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? type,
    String? seats,
    bool? isVerified,
    bool? isForSale,
    bool? isForRent,
  }) {
    return CarModel(
      id: id ?? this.id,
      title: title ?? this.title,
      make: make ?? this.make,
      model: model ?? this.model,
      year: year ?? this.year,
      color: color ?? this.color,
      price: price ?? this.price,
      mileage: mileage ?? this.mileage,
      description: description ?? this.description,
      features: features ?? this.features,
      images: images ?? this.images,
      location: location ?? this.location,
      transmission: transmission ?? this.transmission,
      fuel: fuel ?? this.fuel,
      sellerId: sellerId ?? this.sellerId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      type: type ?? this.type,
      seats: seats ?? this.seats,
      isVerified: isVerified ?? this.isVerified,
      isForSale: isForSale ?? this.isForSale,
      isForRent: isForRent ?? this.isForRent,
    );
  }
}
