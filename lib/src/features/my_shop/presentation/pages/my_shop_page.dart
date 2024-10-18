import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class MyShopPage extends StatelessWidget {
  const MyShopPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Shop'),
      ),
      body:
          Consumer2<UserProvider, CarsProvider>(builder: (context, up, cp, _) {
        String uid = up.firebaseUser!.uid;
        List<CarEntity> fc =
            cp.cars!.where((car) => car.sellerId == uid).toList();
        SellerModel me = up.cSeller!;
        String url = me.photoURL; // Example URL

        String finalUrl;

        if (url.startsWith('ww')) {
          finalUrl = url;
        } else {
          finalUrl = '${Ac.baseUrl}$url';
        }
        return CustomScrollView(
          slivers: [
            // const SliverToBoxAdapter(
            //   child: ThickDevider(),
            // ),
            // First Container (SliverToBoxAdapter)
            SliverToBoxAdapter(
              child: InkWell(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    "/editSeller",
                    arguments: me,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.all(10),
                  height: 130,
                  child: Row(
                    children: [
                      CustomContainer(
                        width: 120,
                        height: 120,
                        image: DecorationImage(image: NetworkImage(finalUrl)),
                      ),
                      const SpaceX(20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const SpaceY(20),
                          TextDef(
                            me.dealershipName,
                            fontSize: 25,
                          ),
                          const SpaceY(1),
                          TextDef(
                            me.location,
                            fontSize: 15,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // const SliverToBoxAdapter(
            //   child: ThickDevider(),
            // ),
            // Second Container (SliverToBoxAdapter)
            SliverToBoxAdapter(
              child: CustomContainer(
                ontap: () {
                  Navigator.pushNamed(context, "/addNew");
                },
                margin: const EdgeInsets.all(10),
                height: 100,
                child: const Center(
                  child: Text(
                    'Add New Car',
                    style: TextStyle(
                      fontSize: 24,
                    ),
                  ),
                ),
              ),
            ),
            // const SliverToBoxAdapter(
            //   child: ThickDevider(),
            // ),
            SliverToBoxAdapter(
              child: SizedBox(
                height: 100,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Row(
                    children: [
                      const TextDef(
                        'Garrage',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const Spacer(),
                      TextDef(
                        '${fc.length} Car(s)',
                        fontSize: 18,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            // SliverList
            SliverList(
              delegate: SliverChildBuilderDelegate(
                (context, index) {
                  return fc.isEmpty
                      ? const CarShortListLoadingTile()
                      : CarShortListTile(
                          car: fc[index],
                        );
                },
                childCount: fc.length, // Number of items in the SliverList
              ),
            ),
          ],
        );
      }),
    );
  }
}
