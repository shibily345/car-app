import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:car_app_beta/src/widgets/buttons/glass_button.dart';
import 'package:car_app_beta/src/widgets/cached_image.dart';

class MyShopPage extends StatelessWidget {
  const MyShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body: Consumer2<UserProvider, CarsProvider>(
        builder: (context, userProvider, carsProvider, _) {
          final String uid = userProvider.firebaseUser!.uid;
          final List<CarEntity> filteredCars =
              carsProvider.cars!.where((car) => car.sellerId == uid).toList();
          final SellerModel seller = userProvider.cSeller!;
          final String imageUrl = _getImageUrl(seller.photoURL);

          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: SellerInfoCard(seller: seller, imageUrl: imageUrl),
              ),
              SliverToBoxAdapter(
                child: PostNewAdButton(),
              ),
              SliverToBoxAdapter(
                child: GarageHeader(carCount: filteredCars.length),
              ),
              SliverList(
                delegate: SliverChildBuilderDelegate(
                  (context, index) {
                    return filteredCars.isEmpty
                        ? const CarShortListLoadingTile()
                        : CarShortListTile(car: filteredCars[index]);
                  },
                  childCount: filteredCars.length,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  String _getImageUrl(String url) {
    return url.startsWith('ww') ? url : '${Ac.baseUrl}$url';
  }
}

class SellerInfoCard extends StatelessWidget {
  final SellerModel seller;
  final String imageUrl;

  const SellerInfoCard({
    required this.seller,
    required this.imageUrl,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        Navigator.pushNamed(
          context,
          "/editSeller",
          arguments: seller,
        );
      },
      child: Container(
        margin: const EdgeInsets.all(10),
        height: 130,
        child: Row(
          children: [
            horizontalSpaceSmall,
            CachedImageWithShimmer(
              width: 100,
              height: 100,
              imageUrl: imageUrl,
            ),
            const SpaceX(20),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SpaceY(20),
                TextDef(
                  seller.dealershipName,
                  fontSize: 25,
                ),
                const SpaceY(1),
                TextDef(
                  seller.location,
                  fontSize: 15,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class PostNewAdButton extends StatelessWidget {
  const PostNewAdButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: GlassButton(
        icon: FontAwesomeIcons.plus,
        onPressed: () {
          Navigator.pushNamed(context, "/addNew");
        },
        height: 60,
        label: 'Post new ad',
      ),
    );
  }
}

class GarageHeader extends StatelessWidget {
  final int carCount;

  const GarageHeader({required this.carCount, super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 100,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Row(
          children: [
            const TextDef(
              'Garage',
              style: TextStyle(
                color: Colors.black,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const Spacer(),
            TextDef(
              '$carCount Vehicle(s)',
              fontSize: 18,
            ),
            
          ],
        ),
      ),
    );
  }
}
