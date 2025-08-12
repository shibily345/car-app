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
import 'package:car_app_beta/src/features/cars/presentation/pages/profile/edit_profile_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/profile/about_page.dart';
import 'package:car_app_beta/src/features/cars/presentation/pages/search/search.dart';
import 'package:car_app_beta/src/features/home/home_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/add_product_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/car_update_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/edit_seller_detail_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/my_shop_page.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/pages/promote_page/add_new.dart';
import 'package:car_app_beta/src/features/rental/presentation/pages/add_rental_car_page.dart';
import 'package:car_app_beta/src/features/rental/presentation/pages/rental_list_page.dart';
import 'package:car_app_beta/src/features/rental/presentation/pages/update_rental_car_page.dart';
import 'package:car_app_beta/src/features/sale/presentation/pages/add_sale_page.dart';
import 'package:car_app_beta/src/features/sale/presentation/pages/edit_sale_page.dart';
import 'package:car_app_beta/src/features/sale/presentation/pages/sale_list_page.dart';
import 'package:car_app_beta/src/features/skeleton/splash_page.dart';
import 'package:car_app_beta/src/features/skeleton/widgets/bottom_nav_home.dart';
import 'package:car_app_beta/src/features/settings/settings.dart';
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
      case '/editProfile':
        return _materialRoute(const EditProfilePage());
      case '/about':
        return _materialRoute(const AboutPage());
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
      case '/addRentalCar':
        return MaterialPageRoute(
          builder: (context) => const AddRentalCarPage(),
          settings: settings,
        );
      case '/rentalList':
        return _materialRoute(const RentalListPage());
      case '/updateRentalCar':
        return MaterialPageRoute(
          builder: (context) => UpdateRentalCarPage(
            carId: settings.arguments as String,
          ),
          settings: settings,
        );
      case '/addSale':
        return MaterialPageRoute(
          builder: (context) => AddSalePage(
            carId: settings.arguments as String?,
          ),
          settings: settings,
        );
      case '/saleList':
        return _materialRoute(const SaleListPage());
      case '/editSale':
        return MaterialPageRoute(
          builder: (context) => EditSalePage(
            carId: settings.arguments as String,
          ),
          settings: settings,
        );
      case '/settings':
        return _materialRoute(const SettingsPage());

      default:
        return _materialRoute(const SplashScreen());
    }
  }

  static Route<dynamic> _materialRoute(Widget view) {
    return MaterialPageRoute(builder: (_) => view);
  }
}
