import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/widgets/cached_image.dart';

class RentalListPage extends StatefulWidget {
  const RentalListPage({super.key});

  @override
  State<RentalListPage> createState() => _RentalListPageState();
}

class _RentalListPageState extends State<RentalListPage> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      debugPrint('>>>>>>>>>>>>>>>>>>: getting rentals');
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rentalProvider =
          Provider.of<RentalProvider>(context, listen: false);
      if (userProvider.cSeller != null) {
        rentalProvider.getSellerRentals(userProvider.cSeller!.id);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Rental Cars'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: Consumer2<UserProvider, RentalProvider>(
        builder: (context, userProvider, rentalProvider, _) {
          if (rentalProvider.isLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (rentalProvider.errorMessage != null) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextDef(
                    'Error: ${rentalProvider.errorMessage}',
                    style: const TextStyle(color: Colors.red),
                  ),
                  const SpaceY(10),
                  ElevatedButton(
                    onPressed: () {
                      rentalProvider.clearError();
                      if (userProvider.cSeller != null) {
                        rentalProvider
                            .getSellerRentals(userProvider.cSeller!.id);
                      }
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          final rentals = rentalProvider.sellerRentalsState?.data ?? [];

          if (rentals.isEmpty) {
            return const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.car_rental,
                    size: 64,
                    color: Colors.grey,
                  ),
                  SpaceY(10),
                  TextDef(
                    'No rental cars found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey,
                    ),
                  ),
                  SpaceY(5),
                  TextDef(
                    'Add your first rental car to start earning',
                    style: TextStyle(
                      color: Colors.grey,
                    ),
                  ),
                ],
              ),
            );
          }

          return ListView.builder(
            padding: const EdgeInsets.all(16.0),
            itemCount: rentals.length,
            itemBuilder: (context, index) {
              final rental = rentals[index];
              return _buildRentalCard(rental);
            },
          );
        },
      ),
    );
  }

  Widget _buildRentalCard(RentalEntity rental) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 4,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextDef(
                        'Car ID: ${rental.carId}',
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SpaceY(5),
                      TextDef(
                        'Type: ${rental.rentalType.toUpperCase()}',
                        style: const TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 8.0,
                    vertical: 4.0,
                  ),
                  decoration: BoxDecoration(
                    color: rental.status == 'active'
                        ? Colors.green
                        : Colors.orange,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: TextDef(
                    rental.status.toUpperCase(),
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
            const SpaceY(10),
            _buildPricingInfo(rental.pricing),
            const SpaceY(10),
            _buildAvailabilityInfo(rental.availability),
            const SpaceY(10),
            _buildLocationInfo(rental.pickupLocation),
            const SpaceY(10),
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to edit rental page
                    },
                    icon: const Icon(Icons.edit),
                    label: const Text('Edit'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
                const SpaceX(10),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      // TODO: Navigate to rental details page
                    },
                    icon: const Icon(Icons.info),
                    label: const Text('Details'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPricingInfo(RentalPricingEntity pricing) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Pricing:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SpaceY(5),
        Wrap(
          spacing: 10,
          children: [
            if (pricing.hourly != null)
              _buildPriceChip('Hourly', '\$${pricing.hourly}'),
            if (pricing.daily != null)
              _buildPriceChip('Daily', '\$${pricing.daily}'),
            if (pricing.weekly != null)
              _buildPriceChip('Weekly', '\$${pricing.weekly}'),
            if (pricing.monthly != null)
              _buildPriceChip('Monthly', '\$${pricing.monthly}'),
          ],
        ),
      ],
    );
  }

  Widget _buildPriceChip(String label, String price) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0),
      decoration: BoxDecoration(
        color: Colors.grey[200],
        borderRadius: BorderRadius.circular(12),
      ),
      child: TextDef(
        '$label: $price',
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
      ),
    );
  }

  Widget _buildAvailabilityInfo(RentalAvailabilityEntity availability) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Availability:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SpaceY(5),
        Row(
          children: [
            Icon(
              availability.isAvailable ? Icons.check_circle : Icons.cancel,
              color: availability.isAvailable ? Colors.green : Colors.red,
              size: 16,
            ),
            const SpaceX(5),
            TextDef(
              availability.isAvailable ? 'Available' : 'Not Available',
              style: TextStyle(
                color: availability.isAvailable ? Colors.green : Colors.red,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
        const SpaceY(5),
        TextDef(
          'From: ${availability.availableFrom.toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 12),
        ),
        TextDef(
          'To: ${availability.availableTo.toString().split(' ')[0]}',
          style: const TextStyle(fontSize: 12),
        ),
        if (availability.instantBooking)
          const Row(
            children: [
              Icon(Icons.flash_on, color: Colors.orange, size: 16),
              SpaceX(5),
              TextDef(
                'Instant Booking',
                style: TextStyle(
                  color: Colors.orange,
                  fontSize: 12,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
      ],
    );
  }

  Widget _buildLocationInfo(RentalLocationEntity location) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Pickup Location:',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 14,
          ),
        ),
        const SpaceY(5),
        TextDef(
          location.address,
          style: const TextStyle(fontSize: 12),
        ),
        TextDef(
          '${location.city}, ${location.state} ${location.zipCode}',
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }
}
