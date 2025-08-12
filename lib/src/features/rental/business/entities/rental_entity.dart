import 'package:equatable/equatable.dart';

class RentalEntity extends Equatable {
  final String? id;
  final String sellerId;
  final String carId;
  final String rentalType;
  final RentalPricingEntity pricing;
  final RentalAvailabilityEntity availability;
  final RentalLocationEntity pickupLocation;
  final RentalLocationEntity returnLocation;
  final RentalTermsEntity terms;
  final RentalFeaturesEntity rentalFeatures;
  final RentalOperatingHoursEntity operatingHours;
  final String status;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RentalEntity({
    this.id,
    required this.sellerId,
    required this.carId,
    required this.rentalType,
    required this.pricing,
    required this.availability,
    required this.pickupLocation,
    required this.returnLocation,
    required this.terms,
    required this.rentalFeatures,
    required this.operatingHours,
    this.status = 'active',
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        sellerId,
        carId,
        rentalType,
        pricing,
        availability,
        pickupLocation,
        returnLocation,
        terms,
        rentalFeatures,
        operatingHours,
        status,
        createdAt,
        updatedAt,
      ];

  copyWith({required String rentalType, required RentalPricingEntity pricing, required RentalAvailabilityEntity availability, required RentalLocationEntity pickupLocation, required RentalLocationEntity returnLocation, required RentalTermsEntity terms, required RentalFeaturesEntity rentalFeatures, required RentalOperatingHoursEntity operatingHours}) {}
}

class RentalPricingEntity extends Equatable {
  final double? hourly;
  final double? daily;
  final double? weekly;
  final double? monthly;
  final int minimumRentalPeriod;
  final int maximumRentalPeriod;

  const RentalPricingEntity({
    this.hourly,
    this.daily,
    this.weekly,
    this.monthly,
    required this.minimumRentalPeriod,
    required this.maximumRentalPeriod,
  });

  RentalPricingEntity copyWith({
    double? hourly,
    double? daily,
    double? weekly,
    double? monthly,
    int? minimumRentalPeriod,
    int? maximumRentalPeriod,
  }) {
    return RentalPricingEntity(
      hourly: hourly ?? this.hourly,
      daily: daily ?? this.daily,
      weekly: weekly ?? this.weekly,
      monthly: monthly ?? this.monthly,
      minimumRentalPeriod: minimumRentalPeriod ?? this.minimumRentalPeriod,
      maximumRentalPeriod: maximumRentalPeriod ?? this.maximumRentalPeriod,
    );
  }

  @override
  List<Object?> get props => [
        hourly,
        daily,
        weekly,
        monthly,
        minimumRentalPeriod,
        maximumRentalPeriod,
      ];
}

class RentalAvailabilityEntity extends Equatable {
  final bool isAvailable;
  final DateTime availableFrom;
  final DateTime availableTo;
  final bool instantBooking;
  final int advanceBookingDays;

  const RentalAvailabilityEntity({
    required this.isAvailable,
    required this.availableFrom,
    required this.availableTo,
    required this.instantBooking,
    required this.advanceBookingDays,
  });

  RentalAvailabilityEntity copyWith({
    bool? isAvailable,
    DateTime? availableFrom,
    DateTime? availableTo,
    bool? instantBooking,
    int? advanceBookingDays,
  }) {
    return RentalAvailabilityEntity(
      isAvailable: isAvailable ?? this.isAvailable,
      availableFrom: availableFrom ?? this.availableFrom,
      availableTo: availableTo ?? this.availableTo,
      instantBooking: instantBooking ?? this.instantBooking,
      advanceBookingDays: advanceBookingDays ?? this.advanceBookingDays,
    );
  }

  @override
  List<Object?> get props => [
        isAvailable,
        availableFrom,
        availableTo,
        instantBooking,
        advanceBookingDays,
      ];
}

class RentalLocationEntity extends Equatable {
  final String address;
  final String city;
  final String state;
  final String zipCode;
  final RentalCoordinatesEntity coordinates;
  final bool sameAsPickup;

  const RentalLocationEntity({
    required this.address,
    required this.city,
    required this.state,
    required this.zipCode,
    required this.coordinates,
    this.sameAsPickup = false,
  });

  RentalLocationEntity copyWith({
    String? address,
    String? city,
    String? state,
    String? zipCode,
    RentalCoordinatesEntity? coordinates,
    bool? sameAsPickup,
  }) {
    return RentalLocationEntity(
      address: address ?? this.address,
      city: city ?? this.city,
      state: state ?? this.state,
      zipCode: zipCode ?? this.zipCode,
      coordinates: coordinates ?? this.coordinates,
      sameAsPickup: sameAsPickup ?? this.sameAsPickup,
    );
  }

  @override
  List<Object?> get props => [
        address,
        city,
        state,
        zipCode,
        coordinates,
        sameAsPickup,
      ];
}

class RentalCoordinatesEntity extends Equatable {
  final double latitude;
  final double longitude;

  const RentalCoordinatesEntity({
    required this.latitude,
    required this.longitude,
  });

  @override
  List<Object?> get props => [latitude, longitude];
}

class RentalTermsEntity extends Equatable {
  final int minimumAge;
  final bool licenseRequired;
  final bool internationalLicense;
  final bool insuranceIncluded;
  final double insuranceCost;
  final bool depositRequired;
  final double depositAmount;
  final int mileageLimit;
  final double overMileageCharge;
  final String fuelPolicy;
  final String cancellationPolicy;
  final double cancellationFee;

  const RentalTermsEntity({
    required this.minimumAge,
    required this.licenseRequired,
    required this.internationalLicense,
    required this.insuranceIncluded,
    required this.insuranceCost,
    required this.depositRequired,
    required this.depositAmount,
    required this.mileageLimit,
    required this.overMileageCharge,
    required this.fuelPolicy,
    required this.cancellationPolicy,
    required this.cancellationFee,
  });

  RentalTermsEntity copyWith({
    int? minimumAge,
    bool? licenseRequired,
    bool? internationalLicense,
    bool? insuranceIncluded,
    double? insuranceCost,
    bool? depositRequired,
    double? depositAmount,
    int? mileageLimit,
    double? overMileageCharge,
    String? fuelPolicy,
    String? cancellationPolicy,
    double? cancellationFee,
  }) {
    return RentalTermsEntity(
      minimumAge: minimumAge ?? this.minimumAge,
      licenseRequired: licenseRequired ?? this.licenseRequired,
      internationalLicense: internationalLicense ?? this.internationalLicense,
      insuranceIncluded: insuranceIncluded ?? this.insuranceIncluded,
      insuranceCost: insuranceCost ?? this.insuranceCost,
      depositRequired: depositRequired ?? this.depositRequired,
      depositAmount: depositAmount ?? this.depositAmount,
      mileageLimit: mileageLimit ?? this.mileageLimit,
      overMileageCharge: overMileageCharge ?? this.overMileageCharge,
      fuelPolicy: fuelPolicy ?? this.fuelPolicy,
      cancellationPolicy: cancellationPolicy ?? this.cancellationPolicy,
      cancellationFee: cancellationFee ?? this.cancellationFee,
    );
  }

  @override
  List<Object?> get props => [
        minimumAge,
        licenseRequired,
        internationalLicense,
        insuranceIncluded,
        insuranceCost,
        depositRequired,
        depositAmount,
        mileageLimit,
        overMileageCharge,
        fuelPolicy,
        cancellationPolicy,
        cancellationFee,
      ];
}

class RentalFeaturesEntity extends Equatable {
  final bool gps;
  final bool childSeat;
  final double childSeatCost;
  final bool additionalDriver;
  final double additionalDriverCost;
  final bool roadsideAssistance;
  final double roadsideAssistanceCost;
  final bool winterTires;
  final double winterTiresCost;

  const RentalFeaturesEntity({
    required this.gps,
    required this.childSeat,
    required this.childSeatCost,
    required this.additionalDriver,
    required this.additionalDriverCost,
    required this.roadsideAssistance,
    required this.roadsideAssistanceCost,
    required this.winterTires,
    required this.winterTiresCost,
  });

  RentalFeaturesEntity copyWith({
    bool? gps,
    bool? childSeat,
    double? childSeatCost,
    bool? additionalDriver,
    double? additionalDriverCost,
    bool? roadsideAssistance,
    double? roadsideAssistanceCost,
    bool? winterTires,
    double? winterTiresCost,
  }) {
    return RentalFeaturesEntity(
      gps: gps ?? this.gps,
      childSeat: childSeat ?? this.childSeat,
      childSeatCost: childSeatCost ?? this.childSeatCost,
      additionalDriver: additionalDriver ?? this.additionalDriver,
      additionalDriverCost: additionalDriverCost ?? this.additionalDriverCost,
      roadsideAssistance: roadsideAssistance ?? this.roadsideAssistance,
      roadsideAssistanceCost:
          roadsideAssistanceCost ?? this.roadsideAssistanceCost,
      winterTires: winterTires ?? this.winterTires,
      winterTiresCost: winterTiresCost ?? this.winterTiresCost,
    );
  }

  @override
  List<Object?> get props => [
        gps,
        childSeat,
        childSeatCost,
        additionalDriver,
        additionalDriverCost,
        roadsideAssistance,
        roadsideAssistanceCost,
        winterTires,
        winterTiresCost,
      ];
}

class RentalOperatingHoursEntity extends Equatable {
  final RentalHoursEntity pickupHours;
  final RentalHoursEntity returnHours;
  final RentalWeekendHoursEntity weekendHours;

  const RentalOperatingHoursEntity({
    required this.pickupHours,
    required this.returnHours,
    required this.weekendHours,
  });

  RentalOperatingHoursEntity copyWith({
    RentalHoursEntity? pickupHours,
    RentalHoursEntity? returnHours,
    RentalWeekendHoursEntity? weekendHours,
  }) {
    return RentalOperatingHoursEntity(
      pickupHours: pickupHours ?? this.pickupHours,
      returnHours: returnHours ?? this.returnHours,
      weekendHours: weekendHours ?? this.weekendHours,
    );
  }

  @override
  List<Object?> get props => [pickupHours, returnHours, weekendHours];
}

class RentalHoursEntity extends Equatable {
  final String start;
  final String end;

  const RentalHoursEntity({
    required this.start,
    required this.end,
  });

  RentalHoursEntity copyWith({
    String? start,
    String? end,
  }) {
    return RentalHoursEntity(
      start: start ?? this.start,
      end: end ?? this.end,
    );
  }

  @override
  List<Object?> get props => [start, end];
}

class RentalWeekendHoursEntity extends Equatable {
  final bool pickup;
  final bool return_;

  const RentalWeekendHoursEntity({
    required this.pickup,
    required this.return_,
  });

  RentalWeekendHoursEntity copyWith({
    bool? pickup,
    bool? return_,
  }) {
    return RentalWeekendHoursEntity(
      pickup: pickup ?? this.pickup,
      return_: return_ ?? this.return_,
    );
  }

  @override
  List<Object?> get props => [pickup, return_];
}
