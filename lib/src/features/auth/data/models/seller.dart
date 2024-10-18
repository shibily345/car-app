import 'package:car_app_beta/src/features/auth/business/entities/seller.dart';

class SellerModel extends SellerEntity {
  const SellerModel({
    required super.uid,
    required super.email,
    required super.displayName,
    required super.photoURL,
    required super.dealershipName,
    required super.contactNumber,
    required super.location,
    required super.id,
  });

  // Factory constructor to create a SellerModel from JSON data
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    return SellerModel(
      id: json['_id'],
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      dealershipName: json['dealershipName'],
      contactNumber: json['contactNumber'],
      location: json['location'],
    );
  }

  // Convert SellerModel to a Map (JSON) format
  Map<String, dynamic> toJson() {
    return {
      //'id': id,
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'dealershipName': dealershipName,
      'contactNumber': contactNumber,
      'location': location,
    };
  }
}
