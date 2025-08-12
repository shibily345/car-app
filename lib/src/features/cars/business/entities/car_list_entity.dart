import 'package:equatable/equatable.dart';

class CarEntity extends Equatable {
  final String? id;
  final String? title;
  final String? make;
  final String? model;
  final int? year;
  final String? color;
  final double? price;
  final int? mileage;
  final String? description;
  final List<String>? features;
  final List<String>? images;
  final String? location;
  final String? transmission;
  final String? fuel;
  final String? sellerId;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final String? type;
  final String? seats;
  final bool? isVerified;
  final bool? isForSale;
  final bool? isForRent;

  const CarEntity({
    this.id,
    this.title,
    this.make,
    this.model,
    this.year,
    this.color,
    this.price,
    this.mileage,
    this.description,
    this.features,
    this.images,
    this.location,
    this.transmission,
    this.fuel,
    this.sellerId,
    this.createdAt,
    this.updatedAt,
    this.type,
    this.seats,
    this.isVerified = false,
    this.isForSale = false,
    this.isForRent = false,
  });

  @override
  List<Object?> get props {
    return [
      id,
      title,
      make,
      model,
      year,
      color,
      price,
      mileage,
      description,
      features,
      images,
      location,
      transmission,
      fuel,
      sellerId,
      createdAt,
      updatedAt,
      type,
      seats,
      isVerified,
      isForSale,
      isForRent,
    ];
  }
}
