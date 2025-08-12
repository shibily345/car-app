import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';

class RentalModel extends RentalEntity {
  const RentalModel({
    super.id,
    required super.sellerId,
    required super.carId,
    required super.rentalType,
    required super.pricing,
    required super.availability,
    required super.pickupLocation,
    required super.returnLocation,
    required super.terms,
    required super.rentalFeatures,
    required super.operatingHours,
    super.status,
    super.createdAt,
    super.updatedAt,
  });

  factory RentalModel.fromJson(Map<String, dynamic> json) {
    return RentalModel(
      id: json['_id'],
      sellerId:
          json['sellerId'] is Map ? json['sellerId']['_id'] : json['sellerId'],
      carId: json['carId'] is Map ? json['carId']['_id'] : json['carId'],
      rentalType: json['rentalType'],
      pricing: RentalPricingModel.fromJson(json['pricing']),
      availability: RentalAvailabilityModel.fromJson(json['availability']),
      pickupLocation: RentalLocationModel.fromJson(json['pickupLocation']),
      returnLocation: RentalLocationModel.fromJson(json['returnLocation']),
      terms: RentalTermsModel.fromJson(json['terms']),
      rentalFeatures: RentalFeaturesModel.fromJson(json['rentalFeatures']),
      operatingHours:
          RentalOperatingHoursModel.fromJson(json['operatingHours']),
      status: json['status'] ?? 'active',
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'sellerId': sellerId,
      'carId': carId,
      'rentalType': rentalType,
      'pricing': (pricing as RentalPricingModel).toJson(),
      'availability': (availability as RentalAvailabilityModel).toJson(),
      'pickupLocation': (pickupLocation as RentalLocationModel).toJson(),
      'returnLocation': (returnLocation as RentalLocationModel).toJson(),
      'terms': (terms as RentalTermsModel).toJson(),
      'rentalFeatures': (rentalFeatures as RentalFeaturesModel).toJson(),
      // Do NOT include operatingHours, status, createdAt, updatedAt, or any null/extra fields
    };
  }

  static RentalModel withDefaults({
    String? id,
    String? sellerId,
    String? carId,
    String? rentalType,
    RentalPricingModel? pricing,
    RentalAvailabilityModel? availability,
    RentalLocationModel? pickupLocation,
    RentalLocationModel? returnLocation,
    RentalTermsModel? terms,
    RentalFeaturesModel? rentalFeatures,
    RentalOperatingHoursModel? operatingHours,
    String? status,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    // Helper for checking empty string
    String defaultString(String? value, String def) =>
        (value == null || value.isEmpty) ? def : value;
    double defaultDouble(double? value, double def) =>
        (value == null || value == 0.0) ? def : value;
    int defaultInt(int? value, int def) =>
        (value == null || value == 0) ? def : value;
    bool defaultBool(bool? value, bool def) => value ?? def;

    const defaultPricing = RentalPricingModel(
      hourly: 10,
      daily: 50,
      weekly: 300,
      monthly: 1200,
      minimumRentalPeriod: 1,
      maximumRentalPeriod: 30,
    );
    final defaultAvailability = RentalAvailabilityModel(
      isAvailable: true,
      availableFrom: DateTime.parse("2024-01-01T00:00:00.000Z"),
      availableTo: DateTime.parse("2024-12-31T23:59:59.000Z"),
      instantBooking: true,
      advanceBookingDays: 30,
    );
    const defaultPickupLocation = RentalLocationModel(
      address: "123 Main Street",
      city: "New York",
      state: "NY",
      zipCode: "10001",
      coordinates: RentalCoordinatesModel(
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      sameAsPickup: false,
    );
    const defaultReturnLocation = RentalLocationModel(
      address: "123 Main Street",
      city: "New York",
      state: "NY",
      zipCode: "10001",
      coordinates: RentalCoordinatesModel(
        latitude: 40.7128,
        longitude: -74.0060,
      ),
      sameAsPickup: true,
    );
    const defaultTerms = RentalTermsModel(
      minimumAge: 21,
      licenseRequired: true,
      internationalLicense: false,
      insuranceIncluded: false,
      insuranceCost: 15,
      depositRequired: true,
      depositAmount: 200,
      mileageLimit: 0,
      overMileageCharge: 0.25,
      fuelPolicy: "full-to-full",
      cancellationPolicy: "moderate",
      cancellationFee: 25,
    );
    const defaultFeatures = RentalFeaturesModel(
      gps: true,
      childSeat: false,
      childSeatCost: 10,
      additionalDriver: true,
      additionalDriverCost: 15,
      roadsideAssistance: true,
      roadsideAssistanceCost: 5,
      winterTires: false,
      winterTiresCost: 20,
    );
    const defaultOperatingHours = RentalOperatingHoursModel(
      pickupHours: RentalHoursModel(start: "09:00", end: "17:00"),
      returnHours: RentalHoursModel(start: "09:00", end: "17:00"),
      weekendHours: RentalWeekendHoursModel(pickup: true, return_: true),
    );

    return RentalModel(
      id: id,
      sellerId: defaultString(sellerId, "687c3106e3ba3568ae4896a7"),
      carId: defaultString(carId, "687dd7c02dd4560fad085680"),
      rentalType: defaultString(rentalType, "daily"),
      pricing: pricing == null
          ? defaultPricing
          : RentalPricingModel(
              hourly: defaultDouble(pricing.hourly, 10),
              daily: defaultDouble(pricing.daily, 50),
              weekly: defaultDouble(pricing.weekly, 300),
              monthly: defaultDouble(pricing.monthly, 1200),
              minimumRentalPeriod: defaultInt(pricing.minimumRentalPeriod, 1),
              maximumRentalPeriod: defaultInt(pricing.maximumRentalPeriod, 30),
            ),
      availability: availability == null
          ? defaultAvailability
          : RentalAvailabilityModel(
              isAvailable: defaultBool(availability.isAvailable, true),
              availableFrom: availability.availableFrom,
              availableTo: availability.availableTo,
              instantBooking: defaultBool(availability.instantBooking, true),
              advanceBookingDays:
                  defaultInt(availability.advanceBookingDays, 30),
            ),
      pickupLocation: pickupLocation == null
          ? defaultPickupLocation
          : RentalLocationModel(
              address: defaultString(pickupLocation.address, "123 Main Street"),
              city: defaultString(pickupLocation.city, "New York"),
              state: defaultString(pickupLocation.state, "NY"),
              zipCode: defaultString(pickupLocation.zipCode, "10001"),
              coordinates: pickupLocation.coordinates == null
                  ? defaultPickupLocation.coordinates
                  : RentalCoordinatesModel(
                      latitude: defaultDouble(
                          pickupLocation.coordinates.latitude, 40.7128),
                      longitude: defaultDouble(
                          pickupLocation.coordinates.longitude, -74.0060),
                    ),
              sameAsPickup: false,
            ),
      returnLocation: returnLocation == null
          ? defaultReturnLocation
          : RentalLocationModel(
              address: defaultString(returnLocation.address, "123 Main Street"),
              city: defaultString(returnLocation.city, "New York"),
              state: defaultString(returnLocation.state, "NY"),
              zipCode: defaultString(returnLocation.zipCode, "10001"),
              coordinates: returnLocation.coordinates == null
                  ? defaultReturnLocation.coordinates
                  : RentalCoordinatesModel(
                      latitude: defaultDouble(
                          returnLocation.coordinates.latitude, 40.7128),
                      longitude: defaultDouble(
                          returnLocation.coordinates.longitude, -74.0060),
                    ),
              sameAsPickup: true,
            ),
      terms: terms == null
          ? defaultTerms
          : RentalTermsModel(
              minimumAge: defaultInt(terms.minimumAge, 21),
              licenseRequired: defaultBool(terms.licenseRequired, true),
              internationalLicense:
                  defaultBool(terms.internationalLicense, false),
              insuranceIncluded: defaultBool(terms.insuranceIncluded, false),
              insuranceCost: defaultDouble(terms.insuranceCost, 15),
              depositRequired: defaultBool(terms.depositRequired, true),
              depositAmount: defaultDouble(terms.depositAmount, 200),
              mileageLimit: defaultInt(terms.mileageLimit, 0),
              overMileageCharge: defaultDouble(terms.overMileageCharge, 0.25),
              fuelPolicy: defaultString(terms.fuelPolicy, "full-to-full"),
              cancellationPolicy:
                  defaultString(terms.cancellationPolicy, "moderate"),
              cancellationFee: defaultDouble(terms.cancellationFee, 25),
            ),
      rentalFeatures: rentalFeatures == null
          ? defaultFeatures
          : RentalFeaturesModel(
              gps: defaultBool(rentalFeatures.gps, true),
              childSeat: defaultBool(rentalFeatures.childSeat, false),
              childSeatCost: defaultDouble(rentalFeatures.childSeatCost, 10),
              additionalDriver:
                  defaultBool(rentalFeatures.additionalDriver, true),
              additionalDriverCost:
                  defaultDouble(rentalFeatures.additionalDriverCost, 15),
              roadsideAssistance:
                  defaultBool(rentalFeatures.roadsideAssistance, true),
              roadsideAssistanceCost:
                  defaultDouble(rentalFeatures.roadsideAssistanceCost, 5),
              winterTires: defaultBool(rentalFeatures.winterTires, false),
              winterTiresCost:
                  defaultDouble(rentalFeatures.winterTiresCost, 20),
            ),
      operatingHours: operatingHours == null
          ? defaultOperatingHours
          : RentalOperatingHoursModel(
              pickupHours: operatingHours.pickupHours == null
                  ? defaultOperatingHours.pickupHours
                  : RentalHoursModel(
                      start: defaultString(
                          operatingHours.pickupHours.start, "09:00"),
                      end: defaultString(
                          operatingHours.pickupHours.end, "17:00"),
                    ),
              returnHours: operatingHours.returnHours == null
                  ? defaultOperatingHours.returnHours
                  : RentalHoursModel(
                      start: defaultString(
                          operatingHours.returnHours.start, "09:00"),
                      end: defaultString(
                          operatingHours.returnHours.end, "17:00"),
                    ),
              weekendHours: operatingHours.weekendHours == null
                  ? defaultOperatingHours.weekendHours
                  : RentalWeekendHoursModel(
                      pickup:
                          defaultBool(operatingHours.weekendHours.pickup, true),
                      return_: defaultBool(
                          operatingHours.weekendHours.return_, true),
                    ),
            ),
      status: status ?? 'active',
      createdAt: createdAt,
      updatedAt: updatedAt,
    );
  }
}

class RentalPricingModel extends RentalPricingEntity {
  const RentalPricingModel({
    super.hourly,
    super.daily,
    super.weekly,
    super.monthly,
    required super.minimumRentalPeriod,
    required super.maximumRentalPeriod,
  });

  factory RentalPricingModel.fromJson(Map<String, dynamic> json) {
    return RentalPricingModel(
      hourly: json['hourly']?.toDouble(),
      daily: json['daily']?.toDouble(),
      weekly: json['weekly']?.toDouble(),
      monthly: json['monthly']?.toDouble(),
      minimumRentalPeriod: json['minimumRentalPeriod'],
      maximumRentalPeriod: json['maximumRentalPeriod'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      if (hourly != null) 'hourly': hourly,
      if (daily != null) 'daily': daily,
      if (weekly != null) 'weekly': weekly,
      if (monthly != null) 'monthly': monthly,
      'minimumRentalPeriod': minimumRentalPeriod,
      'maximumRentalPeriod': maximumRentalPeriod,
    };
  }
}

class RentalAvailabilityModel extends RentalAvailabilityEntity {
  const RentalAvailabilityModel({
    required super.isAvailable,
    required super.availableFrom,
    required super.availableTo,
    required super.instantBooking,
    required super.advanceBookingDays,
  });

  factory RentalAvailabilityModel.fromJson(Map<String, dynamic> json) {
    return RentalAvailabilityModel(
      isAvailable: json['isAvailable'],
      availableFrom: DateTime.parse(json['availableFrom']),
      availableTo: DateTime.parse(json['availableTo']),
      instantBooking: json['instantBooking'],
      advanceBookingDays: json['advanceBookingDays'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isAvailable': isAvailable,
      'availableFrom': availableFrom.toIso8601String(),
      'availableTo': availableTo.toIso8601String(),
      'instantBooking': instantBooking,
      'advanceBookingDays': advanceBookingDays,
    };
  }
}

class RentalLocationModel extends RentalLocationEntity {
  const RentalLocationModel({
    required super.address,
    required super.city,
    required super.state,
    required super.zipCode,
    required super.coordinates,
    super.sameAsPickup,
  });

  factory RentalLocationModel.fromJson(Map<String, dynamic> json) {
    return RentalLocationModel(
      address: json['address'],
      city: json['city'],
      state: json['state'],
      zipCode: json['zipCode'],
      coordinates: RentalCoordinatesModel.fromJson(json['coordinates']),
      sameAsPickup: json['sameAsPickup'] ?? false,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'address': address,
      'city': city,
      'state': state,
      'zipCode': zipCode,
      'coordinates': (coordinates as RentalCoordinatesModel).toJson(),
      'sameAsPickup': sameAsPickup,
    };
  }
}

class RentalCoordinatesModel extends RentalCoordinatesEntity {
  const RentalCoordinatesModel({
    required super.latitude,
    required super.longitude,
  });

  factory RentalCoordinatesModel.fromJson(Map<String, dynamic> json) {
    return RentalCoordinatesModel(
      latitude: json['latitude'].toDouble(),
      longitude: json['longitude'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
    };
  }
}

class RentalTermsModel extends RentalTermsEntity {
  const RentalTermsModel({
    required super.minimumAge,
    required super.licenseRequired,
    required super.internationalLicense,
    required super.insuranceIncluded,
    required super.insuranceCost,
    required super.depositRequired,
    required super.depositAmount,
    required super.mileageLimit,
    required super.overMileageCharge,
    required super.fuelPolicy,
    required super.cancellationPolicy,
    required super.cancellationFee,
  });

  factory RentalTermsModel.fromJson(Map<String, dynamic> json) {
    return RentalTermsModel(
      minimumAge: json['minimumAge'],
      licenseRequired: json['licenseRequired'],
      internationalLicense: json['internationalLicense'],
      insuranceIncluded: json['insuranceIncluded'],
      insuranceCost: json['insuranceCost'].toDouble(),
      depositRequired: json['depositRequired'],
      depositAmount: json['depositAmount'].toDouble(),
      mileageLimit: json['mileageLimit'],
      overMileageCharge: json['overMileageCharge'].toDouble(),
      fuelPolicy: json['fuelPolicy'],
      cancellationPolicy: json['cancellationPolicy'],
      cancellationFee: json['cancellationFee'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'minimumAge': minimumAge,
      'licenseRequired': licenseRequired,
      'internationalLicense': internationalLicense,
      'insuranceIncluded': insuranceIncluded,
      'insuranceCost': insuranceCost,
      'depositRequired': depositRequired,
      'depositAmount': depositAmount,
      'mileageLimit': mileageLimit,
      'overMileageCharge': overMileageCharge,
      'fuelPolicy': fuelPolicy,
      'cancellationPolicy': cancellationPolicy,
      'cancellationFee': cancellationFee,
    };
  }
}

class RentalFeaturesModel extends RentalFeaturesEntity {
  const RentalFeaturesModel({
    required super.gps,
    required super.childSeat,
    required super.childSeatCost,
    required super.additionalDriver,
    required super.additionalDriverCost,
    required super.roadsideAssistance,
    required super.roadsideAssistanceCost,
    required super.winterTires,
    required super.winterTiresCost,
  });

  factory RentalFeaturesModel.fromJson(Map<String, dynamic> json) {
    return RentalFeaturesModel(
      gps: json['gps'],
      childSeat: json['childSeat'],
      childSeatCost: json['childSeatCost'].toDouble(),
      additionalDriver: json['additionalDriver'],
      additionalDriverCost: json['additionalDriverCost'].toDouble(),
      roadsideAssistance: json['roadsideAssistance'],
      roadsideAssistanceCost: json['roadsideAssistanceCost'].toDouble(),
      winterTires: json['winterTires'],
      winterTiresCost: json['winterTiresCost'].toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'gps': gps,
      'childSeat': childSeat,
      'childSeatCost': childSeatCost,
      'additionalDriver': additionalDriver,
      'additionalDriverCost': additionalDriverCost,
      'roadsideAssistance': roadsideAssistance,
      'roadsideAssistanceCost': roadsideAssistanceCost,
      'winterTires': winterTires,
      'winterTiresCost': winterTiresCost,
    };
  }
}

class RentalOperatingHoursModel extends RentalOperatingHoursEntity {
  const RentalOperatingHoursModel({
    required super.pickupHours,
    required super.returnHours,
    required super.weekendHours,
  });

  factory RentalOperatingHoursModel.fromJson(Map<String, dynamic> json) {
    return RentalOperatingHoursModel(
      pickupHours: RentalHoursModel.fromJson(json['pickupHours']),
      returnHours: RentalHoursModel.fromJson(json['returnHours']),
      weekendHours: RentalWeekendHoursModel.fromJson(json['weekendHours']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickupHours': (pickupHours as RentalHoursModel).toJson(),
      'returnHours': (returnHours as RentalHoursModel).toJson(),
      'weekendHours': (weekendHours as RentalWeekendHoursModel).toJson(),
    };
  }
}

class RentalHoursModel extends RentalHoursEntity {
  const RentalHoursModel({
    required super.start,
    required super.end,
  });

  factory RentalHoursModel.fromJson(Map<String, dynamic> json) {
    return RentalHoursModel(
      start: json['start'],
      end: json['end'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'start': start,
      'end': end,
    };
  }
}

class RentalWeekendHoursModel extends RentalWeekendHoursEntity {
  const RentalWeekendHoursModel({
    required super.pickup,
    required super.return_,
  });

  factory RentalWeekendHoursModel.fromJson(Map<String, dynamic> json) {
    return RentalWeekendHoursModel(
      pickup: json['pickup'],
      return_: json['return'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pickup': pickup,
      'return': return_,
    };
  }
}
