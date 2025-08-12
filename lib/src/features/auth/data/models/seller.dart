import 'package:car_app_beta/src/features/auth/business/entities/seller.dart';

class SellerModel extends SellerEntity {
  const SellerModel({
    required super.id,
    required super.uid,
    required super.email,
    required super.displayName,
    required super.photoURL,
    required super.dealershipName,
    required super.contactNumber,
    required super.location,
    super.latitude,
    super.longitude,
  });

  // Factory constructor to create a SellerModel from JSON data
  factory SellerModel.fromJson(Map<String, dynamic> json) {
    // Handle coordinates from nested object
    double? latitude;
    double? longitude;

    if (json['coordinates'] != null) {
      final coordinates = json['coordinates'];
      latitude = coordinates['latitude']?.toDouble();
      longitude = coordinates['longitude']?.toDouble();
    }

    return SellerModel(
      id: json['_id'],
      uid: json['uid'],
      email: json['email'],
      displayName: json['displayName'],
      photoURL: json['photoURL'],
      dealershipName: json['dealershipName'],
      contactNumber: json['contactNumber'],
      location: json['location'],
      latitude: latitude,
      longitude: longitude,
    );
  }

  // Convert SellerModel to a Map (JSON) format
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      // 'id': id,
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'photoURL': photoURL,
      'dealershipName': dealershipName,
      'contactNumber': contactNumber,
      'location': location,
    };

    // Add coordinates if they exist
    if (latitude != null && longitude != null) {
      data['coordinates'] = {
        'latitude': latitude,
        'longitude': longitude,
      };
    }

    return data;
  }

  // Copy with method for easy updates
  SellerModel copyWith({
    String? id,
    String? uid,
    String? email,
    String? displayName,
    String? photoURL,
    String? dealershipName,
    String? contactNumber,
    String? location,
    double? latitude,
    double? longitude,
  }) {
    return SellerModel(
      id: id ?? this.id,
      uid: uid ?? this.uid,
      email: email ?? this.email,
      displayName: displayName ?? this.displayName,
      photoURL: photoURL ?? this.photoURL,
      dealershipName: dealershipName ?? this.dealershipName,
      contactNumber: contactNumber ?? this.contactNumber,
      location: location ?? this.location,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
