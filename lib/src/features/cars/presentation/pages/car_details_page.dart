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
      appBar: _buildAppBar(context),
      body: ListView(
        children: [
          _buildImageSlider(car),
          const SizedBox(height: 16),
          _buildDetailsSection(context, theme, size, seller),
          const Divider(),
          _buildConnectSection(seller, car, context),
        ],
      ),
    );
  }

  SellerModel _getSeller(BuildContext context) {
    return context.watch<UserProvider>().allSellers!.firstWhere(
          (user) => user.uid == car.sellerId,
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
      actions: [
        IconButton(
          onPressed: () {
            if (context
                .read<UserProvider>()
                .currentFavorites
                .contains(car.id!)) {
              context.read<UserProvider>().removeProductFromFavorites(car.id!);
            } else {
              context.read<UserProvider>().addProductToFavorites(car.id!);
            }
          },
          icon: context.read<UserProvider>().currentFavorites.contains(car.id!)
              ? Icon(FontAwesomeIcons.heartCircleCheck)
              : Icon(FontAwesomeIcons.heart),
        ),
        15.spaceX,
      ],
    );
  }

  Widget _buildConnectSection(
      SellerModel seller, CarEntity car, BuildContext context) {
    final sellerImageUrl = seller.photoURL.startsWith('ww')
        ? seller.photoURL
        : '${Ac.baseUrl}${seller.photoURL}';
    var th = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(bottom: 30.0),
      child: GlassCard(
        // height: 250,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(
              'Sell by:',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: th.primaryColor,
              ),
            ),
            20.spaceY,
            Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: NetworkImage(sellerImageUrl),
                ),
                10.w.spaceX,
                SizedBox(
                  width: 190.w,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      TextDef(
                        seller.dealershipName,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                      TextDef(
                        seller.location,
                        fontSize: 14,
                        fontWeight: FontWeight.normal,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            20.spaceY,
            _buildChatButton(seller, car, context),
            10.spaceY,
            _buildCallButton(seller, context),
          ],
        ),
      ),
    );
  }

  Widget _buildChatButton(
      SellerModel seller, CarEntity car, BuildContext context) {
    return GlassButton(
      width: screenWidth(context),
      onPressed: () async {
        final url =
            "https://wa.me/${seller.contactNumber}?text=Hi%2C%20I'm%20interested%20in%20your%20${car.make}%20${car.model}%20Car%20listed%20on%20Carzone.%20Let's%20discuss%20further.";
        await _launchUrl(url);
      },
      label: "Chat",
      icon: Icons.chat,
    );
  }

  Widget _buildCallButton(SellerModel seller, BuildContext context) {
    return GlassButton(
      width: screenWidth(context),
      onPressed: () async {
        final callUri = Uri(scheme: 'tel', path: seller.contactNumber);
        if (await canLaunchUrl(callUri)) {
          await launchUrl(callUri);
        } else {
          throw 'Could not launch $callUri';
        }
      },
      label: "Call",
      icon: Icons.call,
    );
  }

  Widget _buildImageSlider(CarEntity car) {
    return SizedBox(
      height: 400.h,
      child: ImageSlider(images: car.images!),
    );
  }

  Widget _buildDetailsSection(
    BuildContext context,
    ThemeData theme,
    Size size,
    SellerModel seller,
  ) {
    return Container(
      decoration: const BoxDecoration(
        borderRadius: BorderRadius.only(
          topLeft: Radius.elliptical(40, 20),
          topRight: Radius.elliptical(40, 20),
        ),
      ),
      child: Column(
        children: [
          30.spaceY,
          _buildCarTitle(),
          _buildPriceAndLocationRow(),
          _buildCarDetails(),
          _buildFeaturesSection(theme, size),
          20.spaceY,
          _buildDescriptionSection(theme, size),
          40.spaceY,
        ],
      ),
    );
  }

  Widget _buildPriceAndLocationRow() {
    return Row(
      children: [
        PriceSec(price: car.price!.toString()),
        const Spacer(),
        const Icon(Icons.location_on, size: 15),
        TextDef(
          car.location!,
          fontSize: 18,
        ),
        20.spaceX,
      ],
    );
  }

  Widget _buildCarTitle() {
    return Row(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: TextDef(
            "${car.make!} ${car.model!}",
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }

  Widget _buildCarDetails() {
    return Padding(
      padding: const EdgeInsets.all(18.0),
      child: GridView.count(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 2.5,
        children: [
          DBox(
              icon: Icons.local_gas_station_rounded,
              label: "Fuel",
              value: car.fuel!),
          DBox(
              icon: Icons.garage_rounded,
              label: "Transmission",
              value: car.transmission!),
          DBox(
              icon: Icons.date_range_rounded,
              label: "Year",
              value: car.year!.toString()),
          DBox(
              icon: Icons.flag_rounded,
              label: "Mileage",
              value: "${car.mileage} km"),
        ],
      ),
    );
  }

  Widget _buildFeaturesSection(ThemeData theme, Size size) {
    return SizedBox(
      width: size.width,
      child: DetailsSec(
        th: theme,
        details: car.features!,
      ),
    );
  }

  Widget _buildDescriptionSection(ThemeData theme, Size size) {
    return SizedBox(
      width: size.width,
      child: DescSec(
        th: theme,
        description: car.description!,
      ),
    );
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
      // width: 180,
      // height: 60,
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
