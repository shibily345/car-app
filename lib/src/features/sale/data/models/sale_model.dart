import '../../business/entities/sale_entity.dart';
import 'package:flutter/foundation.dart';

class SaleModel extends SaleEntity {
  const SaleModel({
    super.id,
    required super.sellerId,
    required super.carId,
    required super.price,
    required super.isAvailable,
    required super.status,
    required super.description,
    required super.coordinates,
    required super.documents,
    required super.statistics,
    super.createdAt,
    super.updatedAt,
  });

  factory SaleModel.fromJson(Map<String, dynamic> json) {
    try {
      return SaleModel(
        id: json['_id'],
        sellerId: json['sellerId'] is Map
            ? json['sellerId']['_id']
            : json['sellerId'],
        carId: json['carId'] is Map ? json['carId']['_id'] : json['carId'],
        price: (json['price'] as num).toDouble(),
        isAvailable: json['isAvailable'],
        status: json['status'],
        description: json['description'] ?? '',
        coordinates: json['coordinates'] ??
            {
              'latitude': 25.2048,
              'longitude': 55.2708,
            },
        documents: SaleDocumentsModel.fromJson(json['documents'] ?? {}),
        statistics: SaleStatisticsModel.fromJson(json['statistics'] ?? {}),
        createdAt: json['createdAt'] != null
            ? DateTime.parse(json['createdAt'])
            : null,
        updatedAt: json['updatedAt'] != null
            ? DateTime.parse(json['updatedAt'])
            : null,
      );
    } catch (e) {
      debugPrint('SaleModel.fromJson error: $e');
      debugPrint('SaleModel.fromJson json: $json');
      rethrow;
    }
  }

  Map<String, dynamic> toJson() {
    final documentsJson = documents is SaleDocumentsModel
        ? (documents as SaleDocumentsModel).toJson()
        : SaleDocumentsModel(
            registration: documents.registration,
            inspectionReport: documents.inspectionReport,
            lastMaintenanceDate: documents.lastMaintenanceDate,
            nextMaintenanceDate: documents.nextMaintenanceDate,
          ).toJson();

    final statisticsJson = statistics is SaleStatisticsModel
        ? (statistics as SaleStatisticsModel).toJson()
        : SaleStatisticsModel(
            totalViews: statistics.totalViews,
            totalInquiries: statistics.totalInquiries,
            averageRating: statistics.averageRating,
            totalReviews: statistics.totalReviews,
          ).toJson();

    final json = <String, dynamic>{
      'sellerId': sellerId,
      'carId': carId,
      'price': price,
      'isAvailable': isAvailable,
      'status': status,
      'description': description,
      'coordinates': coordinates,
      'documents': documentsJson,
      'statistics': statisticsJson,
    };

    // Include ID if available (for updates)
    if (id != null && id!.isNotEmpty) {
      json['_id'] = id;
    }

    return json;
  }
}

class SaleDocumentsModel extends SaleDocumentsEntity {
  const SaleDocumentsModel({
    required super.registration,
    required super.inspectionReport,
    required super.lastMaintenanceDate,
    required super.nextMaintenanceDate,
  });

  factory SaleDocumentsModel.fromJson(Map<String, dynamic> json) {
    return SaleDocumentsModel(
      registration: json['registration'] ?? '',
      inspectionReport: json['inspectionReport'] ?? '',
      lastMaintenanceDate: json['lastMaintenanceDate'] != null
          ? DateTime.parse(json['lastMaintenanceDate'])
          : DateTime.now(),
      nextMaintenanceDate: json['nextMaintenanceDate'] != null
          ? DateTime.parse(json['nextMaintenanceDate'])
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'registration': registration,
      'inspectionReport': inspectionReport,
      'lastMaintenanceDate': lastMaintenanceDate.toIso8601String(),
      'nextMaintenanceDate': nextMaintenanceDate.toIso8601String(),
    };
  }
}

class SaleStatisticsModel extends SaleStatisticsEntity {
  const SaleStatisticsModel({
    required super.totalViews,
    required super.totalInquiries,
    required super.averageRating,
    required super.totalReviews,
  });

  factory SaleStatisticsModel.fromJson(Map<String, dynamic> json) {
    return SaleStatisticsModel(
      totalViews: json['totalViews'] ?? 0,
      totalInquiries: json['totalInquiries'] ?? 0,
      averageRating: (json['averageRating'] ?? 0).toDouble(),
      totalReviews: json['totalReviews'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalViews': totalViews,
      'totalInquiries': totalInquiries,
      'averageRating': averageRating,
      'totalReviews': totalReviews,
    };
  }
}
