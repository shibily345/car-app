import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/home/widget.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});
  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    var sz = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        title: const Text('CarZone'),
        centerTitle: false,
      ),
      body: CustomScrollView(
        slivers: <Widget>[
          const SliverToBoxAdapter(
            child: SizedBox(
              height: 200.0,
              child: AdsImageSlider(
                images: [
                  'https://via.placeholder.com/400x200/FF0000/FFFFFF?text=Slide1',
                  'https://via.placeholder.com/400x200/00FF00/FFFFFF?text=Slide2',
                  'https://via.placeholder.com/400x200/0000FF/FFFFFF?text=Slide3',
                  'https://via.placeholder.com/400x200/FFFF00/FFFFFF?text=Slide4',
                ],
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: !context.read<UserProvider>().isSeller
                ? const SizedBox()
                : SizedBox(
                    height: 150.0,
                    child: CustomContainer(
                      ontap: () {
                        Navigator.pushNamed(
                          context,
                          "/myShop",
                        );
                      },
                      margin: const EdgeInsets.all(20),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.shop,
                            size: 50,
                          ),
                          SpaceX(20),
                          TextDef(
                            "My Shop",
                            fontSize: 25,
                            fontWeight: FontWeight.bold,
                          ),
                        ],
                      ),
                    )),
          ),
          Consumer<CarsProvider>(
            builder: (context, cars, state) {
              return SliverList(
                delegate: SliverChildBuilderDelegate(
                  (BuildContext context, int index) {
                    return cars.isloaded!
                        ? CarLisTile(car: cars.cars![index])
                        : const CarListLoadingTile();
                  },
                  childCount: cars.isloaded! ? cars.cars!.length : 5,
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
