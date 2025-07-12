import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/add_seller_detail_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/decision_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/login_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/onboarding_page.dart';
import 'package:car_app_beta/src/features/auth/presentation/pages/register_page.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/book-service/book_service.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/car_details_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/favarates/favarites.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/rent_car/rent_car_home.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/spare_parts/spare_home.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/used_cars/uc_home_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/profile/profile_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/search/search.dart';
import 'package:car_app_beta/src/features/home/home_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/add_product_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/car_update_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/edit_seller_detail_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/my_shop_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/promote_page/add_%20new.dart';
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
      case '/search':
        return _materialRoute(const SearchPage());
      case '/favorite':
        return _materialRoute(const FavoritePage());
      case '/usedCars':
        return _materialRoute(const UsedCarsHome());
      case '/profile':
        return _materialRoute(const ProfilePage());
      case '/login':
        return _materialRoute(const OnboardingPage());
      case '/login2':
        return _materialRoute(const LoginPage());
      case '/register':
        return _materialRoute(const RegisterPage());
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
      case '/rentCar':
        return _materialRoute(const RentCarHome());
      case '/spareParts':
        return _materialRoute(const SparePartsHome());
      case '/bookService':
        return _materialRoute(const BookServiceHome());
      case '/decision':
        return _materialRoute(const DecisionPage());
      case '/newp':
        return _materialRoute(const NewPromotion());

      default:
        return _materialRoute(const SplashScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
