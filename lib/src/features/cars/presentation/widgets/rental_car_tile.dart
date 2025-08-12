import 'package:flutter/material.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:car_app_beta/core/constants/constants.dart';

class RentalCarTile extends StatelessWidget {
  final CarEntity car;
  final RentalEntity? rental;
  final int? index;
  final String? selectedRentalType;
  const RentalCarTile({
    super.key,
    required this.car,
    this.rental,
    this.index,
    this.selectedRentalType,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return GestureDetector(
      onTap: () {
        Navigator.pushNamed(context, "/carDetails", arguments: car);
      },
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 8.h),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(20.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withOpacity(0.1),
              blurRadius: 15,
              offset: const Offset(0, 8),
              spreadRadius: 0,
            ),
            BoxShadow(
              color: theme.colorScheme.onSurface.withOpacity(0.05),
              blurRadius: 5,
              offset: const Offset(0, 2),
              spreadRadius: 0,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Car Image
            _buildImageSection(theme),
            Padding(
              padding: EdgeInsets.all(20.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Price and Date Row
                  _buildPriceDateRow(theme),
                  SizedBox(height: 16.h),
                  // Car Title
                  _buildCarTitle(theme),
                  SizedBox(height: 8.h),
                  // Car Details
                  _buildCarDetails(theme),
                  SizedBox(height: 16.h),
                  // Location
                  _buildLocation(theme),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImageSection(ThemeData theme) {
    final imageUrl = (car.images != null && car.images!.isNotEmpty)
        ? car.images!.first
        : null;
    String displayUrl = '';
    if (imageUrl != null && imageUrl.isNotEmpty) {
      displayUrl =
          imageUrl.startsWith('http') ? imageUrl : (Ac.baseUrl + imageUrl);
    }
    return ClipRRect(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(20.r),
        topRight: Radius.circular(20.r),
      ),
      child: displayUrl.isEmpty
          ? Container(
              height: 220.h,
              width: double.infinity,
              color: theme.colorScheme.onSurface.withOpacity(0.1),
              child: Icon(Icons.directions_car,
                  size: 48.sp,
                  color: theme.colorScheme.onSurface.withOpacity(0.3)),
            )
          : Image.network(
              displayUrl,
              height: 220.h,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) => Container(
                height: 220.h,
                width: double.infinity,
                color: theme.colorScheme.onSurface.withOpacity(0.1),
                child: Icon(Icons.directions_car,
                    size: 48.sp,
                    color: theme.colorScheme.onSurface.withOpacity(0.3)),
              ),
            ),
    );
  }

  Widget _buildPriceDateRow(ThemeData theme) {
    String priceStr = 'AED ${car.price?.toStringAsFixed(0) ?? '0'}';
    String period = '';

    if (rental != null) {
      // Show price based on selected rental type or actual rental type
      if (selectedRentalType != null && selectedRentalType != 'All') {
        // Use the selected rental type from filter
        switch (selectedRentalType!.toLowerCase()) {
          case 'hourly':
            if (rental!.pricing.hourly != null) {
              priceStr = 'AED ${rental!.pricing.hourly!.toStringAsFixed(0)}';
              period = '/hr';
            }
            break;
          case 'daily':
            if (rental!.pricing.daily != null) {
              priceStr = 'AED ${rental!.pricing.daily!.toStringAsFixed(0)}';
              period = '/day';
            }
            break;
          case 'weekly':
            if (rental!.pricing.weekly != null) {
              priceStr = 'AED ${rental!.pricing.weekly!.toStringAsFixed(0)}';
              period = '/wk';
            }
            break;
          case 'monthly':
            if (rental!.pricing.monthly != null) {
              priceStr = 'AED ${rental!.pricing.monthly!.toStringAsFixed(0)}';
              period = '/mo';
            }
            break;
        }
      } else {
        // When "All" is selected, use the actual rental type of the car
        switch (rental!.rentalType.toLowerCase()) {
          case 'hourly':
            if (rental!.pricing.hourly != null) {
              priceStr = 'AED ${rental!.pricing.hourly!.toStringAsFixed(0)}';
              period = '/hr';
            }
            break;
          case 'daily':
            if (rental!.pricing.daily != null) {
              priceStr = 'AED ${rental!.pricing.daily!.toStringAsFixed(0)}';
              period = '/day';
            }
            break;
          case 'weekly':
            if (rental!.pricing.weekly != null) {
              priceStr = 'AED ${rental!.pricing.weekly!.toStringAsFixed(0)}';
              period = '/wk';
            }
            break;
          case 'monthly':
            if (rental!.pricing.monthly != null) {
              priceStr = 'AED ${rental!.pricing.monthly!.toStringAsFixed(0)}';
              period = '/mo';
            }
            break;
          default:
            // Fallback to original logic if rental type is not recognized
            if (rental!.pricing.daily != null) {
              priceStr = 'AED ${rental!.pricing.daily!.toStringAsFixed(0)}';
              period = '/day';
            } else if (rental!.pricing.hourly != null) {
              priceStr = 'AED ${rental!.pricing.hourly!.toStringAsFixed(0)}';
              period = '/hr';
            } else if (rental!.pricing.weekly != null) {
              priceStr = 'AED ${rental!.pricing.weekly!.toStringAsFixed(0)}';
              period = '/wk';
            } else if (rental!.pricing.monthly != null) {
              priceStr = 'AED ${rental!.pricing.monthly!.toStringAsFixed(0)}';
              period = '/mo';
            }
        }
      }
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          '$priceStr$period',
          style: TextStyle(
            color: theme.colorScheme.primary,
            fontSize: 24.sp,
            fontWeight: FontWeight.bold,
          ),
        ),
        // Date (updatedAt)
        Container(
          padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
          decoration: BoxDecoration(
            color: theme.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12.r),
          ),
          child: Text(
            car.updatedAt?.toString().split(' ')[0] ?? '',
            style: TextStyle(
              color: theme.colorScheme.primary,
              fontSize: 12.sp,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCarTitle(ThemeData theme) {
    return Text(
      "${car.make ?? 'Unknown'} ${car.model ?? 'Car'}",
      style: TextStyle(
        fontSize: 20.sp,
        fontWeight: FontWeight.bold,
        color: theme.colorScheme.onSurface,
      ),
      maxLines: 2,
      overflow: TextOverflow.ellipsis,
    );
  }

  Widget _buildCarDetails(ThemeData theme) {
    return Row(
      children: [
        _buildDetailChip(
          theme,
          Icons.local_gas_station,
          car.fuel ?? 'N/A',
          theme.colorScheme.secondary,
        ),
        SizedBox(width: 8.w),
        _buildDetailChip(
          theme,
          Icons.speed,
          '${car.mileage?.toString() ?? '0'} km',
          theme.colorScheme.tertiary,
        ),
        SizedBox(width: 8.w),
        _buildDetailChip(
          theme,
          Icons.calendar_today,
          '${car.year ?? 'N/A'}',
          theme.colorScheme.primary,
        ),
      ],
    );
  }

  Widget _buildDetailChip(
      ThemeData theme, IconData icon, String text, Color color) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 8.w, vertical: 4.h),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8.r),
        border: Border.all(
          color: color.withOpacity(0.2),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14.sp,
            color: color,
          ),
          SizedBox(width: 4.w),
          Text(
            text,
            style: TextStyle(
              fontSize: 12.sp,
              color: color,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLocation(ThemeData theme) {
    String locationStr = car.location ?? 'Location not specified';
    if (rental != null) {
      // Prefer address, then city
      locationStr = rental!.pickupLocation.address.isNotEmpty
          ? rental!.pickupLocation.address
          : rental!.pickupLocation.city;
    }
    return Row(
      children: [
        Icon(
          Icons.location_on,
          size: 16.sp,
          color: theme.colorScheme.primary,
        ),
        SizedBox(width: 6.w),
        Expanded(
          child: Text(
            locationStr,
            style: TextStyle(
              fontSize: 14.sp,
              color: theme.colorScheme.onSurface.withOpacity(0.7),
              fontWeight: FontWeight.w500,
            ),
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }
}
