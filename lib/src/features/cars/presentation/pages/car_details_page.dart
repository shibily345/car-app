import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/home/widget.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProductDetailsPage extends StatelessWidget {
  const ProductDetailsPage({
    required this.car,
    super.key,
  });
  final CarEntity car;
  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);
    SellerModel seller = context.watch<UserProvider>().allSellers!.firstWhere(
          (user) => user.uid == car.sellerId,
          orElse: () => const SellerModel(
              id: "",
              uid: "uid",
              email: "email",
              displayName: "displayName",
              photoURL: "photoURL",
              dealershipName: "dealershipName",
              contactNumber: "contactNumber",
              location: "location"), // Return null if not found
        );

    String finalUrl;

    if (seller.photoURL.startsWith('ww')) {
      finalUrl = seller.photoURL;
    } else {
      finalUrl = '${Ac.baseUrl}${seller.photoURL}';
    }
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
              onPressed: () {
                context.read<UserProvider>().addProductToFavorites(car.id!);
              },
              icon: const Icon(Icons.favorite_border)),
          15.spaceX
        ],
      ),
      bottomNavigationBar: SizedBox(
        height: 100,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            10.spaceX,
            CircleAvatar(
              radius: 20,
              backgroundImage: NetworkImage(finalUrl),
            ),
            10.spaceX,
            SizedBox(width: 90, child: TextDef(seller.dealershipName)),
            const Spacer(),
            OutlineButton(
              onPressed: () async {
                await _launchUrl(
                    "https://wa.me/${seller.contactNumber}?text=Hi%2C%20I'm%20interested%20in%20your%20${car.make}%20${car.model}%20Car%20listed%20on%20Carzone.%20Let's%20discuss%20further.");
              },
              label: "Chat",
              icon: Icons.chat,
            ),
            const Spacer(),
            OutlineButton(
              onPressed: () async {
                final Uri callUri = Uri(
                  scheme: 'tel',
                  path: "tel:${seller.contactNumber}",
                );
                if (await canLaunchUrl(callUri)) {
                  await launchUrl(callUri);
                } else {
                  throw 'Could not launch $callUri';
                }
              },
              icon: Icons.call,
            ),
            const Spacer(),
          ],
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            60.0.spaceX,
            SizedBox(
              height: 300,
              child: ImageSlider(images: car.images!),
            ),
            const SizedBox(height: 16),
            const Divider(),
            PriceSec(
              price: car.price!.toString(),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextDef(
                "${car.make!} ${car.model!}",
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20.0),
              child: TextDef(
                "${car.year!}  ⦿  ${car.fuel!}  ⦿  ${car.transmission!}",
              ),
            ),
            const SizedBox(
              height: 16,
            ),
            Padding(
              padding: const EdgeInsets.all(18.0),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    size: 15,
                  ),
                  TextDef(car.location!)
                ],
              ),
            ),
            const ThickDevider(),
            DetailsSec(
              th: th,
              details: car.features!,
            ),
            const ThickDevider(),
            DescSec(
              th: th,
              description: car.description!,
            ),
            const ThickDevider(),
            const LocationSec(),
          ],
        ),
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
