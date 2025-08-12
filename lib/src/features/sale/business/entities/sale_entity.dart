import 'package:equatable/equatable.dart';

class SaleEntity extends Equatable {
  final String? id;
  final String sellerId;
  final String carId;
  final double price;
  final bool isAvailable;
  final String status; // active, inactive, sold
  final String description;
  final Map<String, dynamic> coordinates;
  final SaleDocumentsEntity documents;
  final SaleStatisticsEntity statistics;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const SaleEntity({
    this.id,
    required this.sellerId,
    required this.carId,
    required this.price,
    required this.isAvailable,
    required this.status,
    required this.description,
    required this.coordinates,
    required this.documents,
    required this.statistics,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [
        id,
        sellerId,
        carId,
        price,
        isAvailable,
        status,
        description,
        coordinates,
        documents,
        statistics,
        createdAt,
        updatedAt,
      ];
}

class SaleDocumentsEntity extends Equatable {
  final String registration;
  final String inspectionReport;
  final DateTime lastMaintenanceDate;
  final DateTime nextMaintenanceDate;

  const SaleDocumentsEntity({
    required this.registration,
    required this.inspectionReport,
    required this.lastMaintenanceDate,
    required this.nextMaintenanceDate,
  });

  @override
  List<Object?> get props => [
        registration,
        inspectionReport,
        lastMaintenanceDate,
        nextMaintenanceDate,
      ];
}

class SaleStatisticsEntity extends Equatable {
  final int totalViews;
  final int totalInquiries;
  final double averageRating;
  final int totalReviews;

  const SaleStatisticsEntity({
    required this.totalViews,
    required this.totalInquiries,
    required this.averageRating,
    required this.totalReviews,
  });

  @override
  List<Object?> get props => [
        totalViews,
        totalInquiries,
        averageRating,
        totalReviews,
      ];
}
