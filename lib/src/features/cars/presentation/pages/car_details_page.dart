import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/glass_button.dart';
import 'package:car_app_beta/src/widgets/cards/glass_card.dart';
import 'package:car_app_beta/src/widgets/cards/gradient_border_card.dart.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/used_cars/widget.dart';
import 'package:car_app_beta/src/extensions.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    required this.car,
    super.key,
  });

  final CarEntity car;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;
    final seller = _getSeller(context);

    return Scaffold(
      backgroundColor: Colors.grey[50],
      appBar: _buildAppBar(context),
      body: CustomScrollView(
        slivers: [
          // Hero Image Section
          SliverToBoxAdapter(
            child: _buildHeroSection(context),
          ),

          // Main Content
          SliverToBoxAdapter(
            child: Container(
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(30),
                  topRight: Radius.circular(30),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Availability Badges
                  _buildAvailabilitySection(context),

                  // Price Section
                  _buildPriceSection(context),

                  // Quick Details Grid
                  _buildQuickDetailsGrid(context),

                  // Additional Details Section
                  _buildAdditionalDetailsSection(context),

                  // Features Section
                  _buildFeaturesSection(theme, size),

                  // Description Section
                  _buildDescriptionSection(theme, size),

                  // Seller Section
                  _buildSellerSection(seller, car, context),

                  const SizedBox(height: 100), // Space for bottom button
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: _buildBottomBar(context),
    );
  }

  Widget _buildHeroSection(BuildContext context) {
    return Stack(
      children: [
        // Image Slider
        _buildImageSlider(car),

        // Gradient Overlay
        Positioned.fill(
          child: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  Colors.transparent,
                  Colors.black.withOpacity(0.3),
                ],
                stops: const [0.7, 1.0],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAvailabilitySection(BuildContext context) {
    final isForSale = car.isForSale ?? false;
    final isForRent = car.isForRent ?? false;

    if (!isForSale && !isForRent) return const SizedBox.shrink();

    return Container(
      margin: const EdgeInsets.only(top: 20, left: 20, right: 20),
      child: Row(
        children: [
          if (isForSale)
            _buildAvailabilityBadge(
              context,
              'For Sale',
              Colors.green,
              Icons.sell,
            ),
          if (isForSale && isForRent) const SizedBox(width: 10),
          if (isForRent)
            _buildAvailabilityBadge(
              context,
              'For Rent',
              Colors.blue,
              Icons.car_rental,
            ),
        ],
      ),
    );
  }

  Widget _buildAvailabilityBadge(
    BuildContext context,
    String text,
    Color color,
    IconData icon,
  ) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withOpacity(0.3)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: color),
          const SizedBox(width: 6),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPriceSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Price
          Row(
            children: [
              Text(
                'AED ${car.price?.toStringAsFixed(0) ?? '0'}',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).primaryColor,
                ),
              ),
              const SizedBox(width: 8),
              if (car.isForRent == true)
                Text(
                  '/day',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
            ],
          ),
          const SizedBox(height: 8),

          // Year and Location
          Row(
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.orange.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Text(
                  car.year?.toString() ?? 'N/A',
                  style: TextStyle(
                    color: Colors.orange[700],
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                car.location ?? 'Location not specified',
                style: TextStyle(
                  color: Colors.grey[600],
                  fontSize: 14,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildQuickDetailsGrid(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 12,
        crossAxisSpacing: 12,
        childAspectRatio: 2.5,
        children: [
          _buildDetailCard(
            context,
            Icons.local_gas_station_rounded,
            "Fuel Type",
            car.fuel ?? 'N/A',
            Colors.green,
          ),
          _buildDetailCard(
            context,
            Icons.settings,
            "Transmission",
            car.transmission ?? 'N/A',
            Colors.blue,
          ),
          _buildDetailCard(
            context,
            Icons.speed,
            "Mileage",
            "${car.mileage?.toString() ?? '0'} km",
            Colors.purple,
          ),
          _buildDetailCard(
            context,
            Icons.event_seat,
            "Seats",
            car.seats ?? 'N/A',
            Colors.orange,
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard(
    BuildContext context,
    IconData icon,
    String label,
    String value,
    Color color,
  ) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[50],
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAdditionalDetailsSection(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Additional Details',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          _buildDetailRow('Color', car.color ?? 'N/A', Icons.palette),
          _buildDetailRow('Type', car.type ?? 'N/A', Icons.category),
          _buildDetailRow(
              'Created', _formatDate(car.createdAt), Icons.calendar_today),
          _buildDetailRow('Updated', _formatDate(car.updatedAt), Icons.update),
          if (car.isVerified == true)
            _buildDetailRow('Status', 'Verified', Icons.verified,
                isVerified: true),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value, IconData icon,
      {bool isVerified = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isVerified ? Colors.green.withOpacity(0.1) : Colors.grey[50],
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isVerified ? Colors.green.withOpacity(0.3) : Colors.grey[200]!,
        ),
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: isVerified ? Colors.green : Colors.grey[600],
            size: 20,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: isVerified ? Colors.green[700] : Colors.black87,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatDate(DateTime? date) {
    if (date == null) return 'N/A';
    return '${date.day}/${date.month}/${date.year}';
  }

  Widget _buildFeaturesSection(ThemeData theme, Size size) {
    if (car.features == null || car.features!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Features',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: car.features!.map((feature) {
              return Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: theme.primaryColor.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: theme.primaryColor.withOpacity(0.3),
                  ),
                ),
                child: Text(
                  feature,
                  style: TextStyle(
                    color: theme.primaryColor,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme, Size size) {
    if (car.description == null || car.description!.isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      margin: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            car.description!,
            style: TextStyle(
              fontSize: 16,
              color: Colors.grey[700],
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSellerSection(
    SellerModel seller,
    CarEntity car,
    BuildContext context,
  ) {
    final sellerImageUrl = seller.photoURL.startsWith('ww')
        ? seller.photoURL
        : '${Ac.baseUrl}${seller.photoURL}';

    return Container(
      margin: const EdgeInsets.all(20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Colors.blue.withOpacity(0.05),
            Colors.purple.withOpacity(0.05),
          ],
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: Colors.grey[200]!),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Contact Seller',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // Seller Info
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: NetworkImage(sellerImageUrl),
                backgroundColor: Colors.grey[300],
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      seller.dealershipName,
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.black87,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.location_on,
                            size: 16, color: Colors.grey[600]),
                        const SizedBox(width: 4),
                        Text(
                          seller.location,
                          style: TextStyle(
                            fontSize: 14,
                            color: Colors.grey[600],
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Action Buttons
          Row(
            children: [
              Expanded(
                child: _buildActionButton(
                  context,
                  'Chat',
                  Icons.chat_bubble_outline,
                  Colors.green,
                  () => _launchWhatsApp(seller, car),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildActionButton(
                  context,
                  'Call',
                  Icons.phone_outlined,
                  Colors.blue,
                  () => _launchCall(seller),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton(
    BuildContext context,
    String label,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return ElevatedButton.icon(
      onPressed: onPressed,
      icon: Icon(icon, size: 20),
      label: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.w600),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 12),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

  Widget _buildBottomBar(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Like Button
          Container(
            decoration: BoxDecoration(
              color: context
                      .read<UserProvider>()
                      .currentFavorites
                      .contains(car.id!)
                  ? Colors.red.withOpacity(0.1)
                  : Colors.grey[100],
              borderRadius: BorderRadius.circular(15),
              border: Border.all(
                color: context
                        .read<UserProvider>()
                        .currentFavorites
                        .contains(car.id!)
                    ? Colors.red.withOpacity(0.3)
                    : Colors.grey[300]!,
              ),
            ),
            child: IconButton(
              onPressed: () {
                if (context
                    .read<UserProvider>()
                    .currentFavorites
                    .contains(car.id!)) {
                  context
                      .read<UserProvider>()
                      .removeProductFromFavorites(car.id!);
                } else {
                  context.read<UserProvider>().addProductToFavorites(car.id!);
                }
              },
              icon: context
                      .read<UserProvider>()
                      .currentFavorites
                      .contains(car.id!)
                  ? const Icon(FontAwesomeIcons.heartCircleCheck,
                      color: Colors.red)
                  : const Icon(FontAwesomeIcons.heart, color: Colors.grey),
            ),
          ),
          const SizedBox(width: 16),

          // Contact Seller Button
          Expanded(
            child: ElevatedButton.icon(
              onPressed: () {
                // Scroll to the bottom of the screen
                final primaryScrollController =
                    PrimaryScrollController.of(context);
                primaryScrollController.animateTo(
                  primaryScrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeInOut,
                );
              },
              icon: const Icon(Icons.chat_bubble_outline),
              label: const Text(
                'Contact Seller',
                style: TextStyle(fontWeight: FontWeight.w600),
              ),
              style: ElevatedButton.styleFrom(
                backgroundColor: Theme.of(context).primaryColor,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 16),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  SellerModel _getSeller(BuildContext context) {
    return context.watch<UserProvider>().allSellers.firstWhere(
          (user) => user.id == car.sellerId,
          orElse: () => const SellerModel(
            id: "",
            uid: "uid",
            email: "email",
            displayName: "displayName",
            photoURL: "photoURL",
            dealershipName: "dealershipName",
            contactNumber: "contactNumber",
            location: "location",
          ),
        );
  }

  AppBar _buildAppBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: Text(
        "${car.make!} ${car.model!}",
        style: const TextStyle(
          color: Colors.black,
          fontWeight: FontWeight.bold,
          fontSize: 18,
        ),
      ),
      leading: Container(
        margin: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(25),
        ),
        child: IconButton(
          onPressed: () => Navigator.pop(context),
          icon: const Icon(Icons.arrow_back_ios, size: 20),
          color: Colors.black87,
        ),
      ),
    );
  }

  Widget _buildImageSlider(CarEntity car) {
    return SizedBox(
      height: 400.h,
      child: ImageSlider(images: car.images!),
    );
  }

  Future<void> _launchWhatsApp(SellerModel seller, CarEntity car) async {
    final url =
        "https://wa.me/${seller.contactNumber}?text=Hi%2C%20I'm%20interested%20in%20your%20${car.make}%20${car.model}%20Car%20listed%20on%20Carzone.%20Let's%20discuss%20further.";
    await _launchUrl(url);
  }

  Future<void> _launchCall(SellerModel seller) async {
    final callUri = Uri(scheme: 'tel', path: seller.contactNumber);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      throw 'Could not launch $callUri';
    }
  }

  Future<void> _launchUrl(String url) async {
    if (!await launchUrl(
      Uri.parse(url),
      mode: LaunchMode.externalApplication,
    )) {
      throw Exception('Could not launch $url');
    }
  }
}

class DBox extends StatelessWidget {
  const DBox({
    super.key,
    required this.value,
    required this.icon,
    required this.label,
  });

  final String value;
  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return GradientBorderCard(
      radius: 10,
      padding: const EdgeInsets.all(0),
      child: Row(
        children: [
          10.spaceX,
          Icon(icon),
          10.spaceX,
          Container(
            color: Colors.black26,
            width: 2,
            height: 40,
          ),
          10.spaceX,
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Ctext(
                label,
                color: Colors.black45,
                fontSize: 14,
              ),
              Ctext(value, fontSize: 16),
            ],
          ),
          20.spaceX,
        ],
      ),
    );
  }
}
