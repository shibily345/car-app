import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class FavoritePage extends StatefulWidget {
  const FavoritePage({super.key});

  @override
  _FavoritePageState createState() => _FavoritePageState();
}

class _FavoritePageState extends State<FavoritePage> {
  @override
  Widget build(BuildContext context) {
    return Consumer2<UserProvider, CarsProvider>(builder: (context, up, cp, _) {
      var favIds = up.getFavoriteProductIds();
      List<CarEntity> favCars = cp.cars!.where((product) {
        return up.currentFavorites.contains(product.id);
      }).toList();
      print(favIds);
      return Scaffold(
        appBar: AppBar(
          title: const TextDef("Favorites"),
          centerTitle: false,
        ),
        body: up.firebaseUser == null
            ? const LoginButton()
            : up.currentFavorites.isEmpty
                ? const Center(child: Text("No favorites yet"))
                : ListView.builder(
                    itemCount: up.currentFavorites.length,
                    itemBuilder: (context, index) {
                      return CarShortListTile(
                        car: favCars[index],
                        onTap: () {
                          Navigator.pushNamed(context, "/carDetails",
                              arguments: favCars[index]);
                        },
                        delete: IconButton(
                            onPressed: () {
                              up.removeProductFromFavorites(favCars[index].id!);
                            },
                            icon: const Icon(Icons.remove_circle)),
                      );
                    },
                  ),
      );
    });
  }
}
