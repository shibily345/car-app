import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/add_seller_detail_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/decision_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/onboarding_page.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/car_details_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/home/home_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/add_product_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/car_update_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/edit_seller_detail_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/my_shop_page.dart';
import 'package:car_app_beta/src/features/skeleton/splash_page.dart';
import 'package:car_app_beta/src/features/skeleton/widgets/bottom_nav_home.dart';
import 'package:flutter/material.dart';

class AppRoutes {
  static Route onGenerateRoutes(RouteSettings settings) {
    switch (settings.name) {
      case '/':
        return _materialRoute(const SplashScreen());
      case '/s':
        return _materialRoute(const SkeletonNav());

      case '/home':
        return _materialRoute(const HomePage());
      case '/login':
        return _materialRoute(const OnboardingPage());
      case '/carDetails':
        return _materialRoute(
            ProductDetailsPage(car: settings.arguments as CarEntity));
      case '/carUpdate':
        return _materialRoute(
            CarUpdatePage(thisCar: settings.arguments as CarEntity));
      case '/editSeller':
        return _materialRoute(EditSellerDetailPage(
            sellerData: settings.arguments as SellerModel));
      case '/addNew':
        return _materialRoute(const AddNewProductPage());
      case '/addSeller':
        return _materialRoute(const AddSellerDetailPage());
      case '/myShop':
        return _materialRoute(const MyShopPage());
      case '/decision':
        return _materialRoute(const DecisionPage());

      default:
        return _materialRoute(const SplashScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
