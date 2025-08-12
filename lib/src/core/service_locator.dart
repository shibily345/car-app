import 'package:car_app_beta/src/features/rental/business/usecases/update_rental_usecase.dart';
import 'package:car_app_beta/src/features/sale/business/repositories/sale_repository.dart';
import 'package:car_app_beta/src/features/sale/business/usecases/create_sale_usecase.dart';
import 'package:car_app_beta/src/features/sale/business/usecases/delete_sale_usecase.dart';
import 'package:car_app_beta/src/features/sale/business/usecases/get_all_sales_usecase.dart';
import 'package:car_app_beta/src/features/sale/business/usecases/get_sale_by_id_usecase.dart';
import 'package:car_app_beta/src/features/sale/business/usecases/update_sale_usecase.dart';
import 'package:car_app_beta/src/features/sale/data/datasources/sale_remote_data_source.dart';
import 'package:car_app_beta/src/features/sale/data/repositories/sale_repository_impl.dart';
import 'package:car_app_beta/src/features/sale/presentation/providers/sale_provider.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';

// Core
import 'package:car_app_beta/core/connection/network_info.dart';

// Auth
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_remote_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_local_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/repositories/seller_repository_impl.dart';
import 'package:car_app_beta/src/features/auth/business/repositories/seller_repo.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/update_seller.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/get_seller.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/get_all.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/edit_seller.dart';

// Cars
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_remote_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/datasources/car_list_local_data_source.dart';
import 'package:car_app_beta/src/features/cars/data/repositories/car_list_repository_impl.dart';
import 'package:car_app_beta/src/features/cars/business/repositories/car_list_repository.dart';
import 'package:car_app_beta/src/features/cars/business/usecases/get_car_list.dart';

// My Shop
import 'package:car_app_beta/src/features/my_shop/data/datasources/car_data_remote_data_source.dart';
import 'package:car_app_beta/src/features/my_shop/data/repositories/car_list_repository_impl.dart';
import 'package:car_app_beta/src/features/my_shop/business/repositories/car_list_repository.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/post_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/edit_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/delete_car_data.dart';

// Rental
import 'package:car_app_beta/src/features/rental/business/repositories/rental_repository.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/create_rental_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/get_seller_rentals_usecase.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/get_all_rentals_usecase.dart';
import 'package:car_app_beta/src/features/rental/data/datasources/rental_remote_data_source.dart';
import 'package:car_app_beta/src/features/rental/data/repositories/rental_repository_impl.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/features/rental/business/usecases/delete_rental_usecase.dart';

final GetIt getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // Core services
  if (!getIt.isRegistered<Dio>()) {
    getIt.registerLazySingleton<Dio>(() => Dio());
  }

  if (!getIt.isRegistered<SharedPreferences>()) {
    final prefs = await SharedPreferences.getInstance();
    getIt.registerLazySingleton<SharedPreferences>(() => prefs);
  }

  if (!getIt.isRegistered<DataConnectionChecker>()) {
    getIt.registerLazySingleton<DataConnectionChecker>(
        () => DataConnectionChecker());
  }

  if (!getIt.isRegistered<NetworkInfo>()) {
    getIt.registerLazySingleton<NetworkInfo>(
        () => NetworkInfoImpl(getIt<DataConnectionChecker>()));
  }

  // Auth data sources
  if (!getIt.isRegistered<SellerRemoteDataSource>()) {
    getIt.registerLazySingleton<SellerRemoteDataSource>(
      () => SellerRemoteDataSourceImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<SellerLocalDataSource>()) {
    getIt.registerLazySingleton<SellerLocalDataSource>(
      () => SellerLocalDataSourceImpl(
          sharedPreferences: getIt<SharedPreferences>()),
    );
  }

  // Auth repositories
  if (!getIt.isRegistered<SellerRepository>()) {
    getIt.registerLazySingleton<SellerRepository>(
      () => SellerRepositoryImpl(
        remoteDataSource: getIt<SellerRemoteDataSource>(),
        localDataSource: getIt<SellerLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
  }

  // Auth use cases
  if (!getIt.isRegistered<AddSeller>()) {
    getIt.registerLazySingleton<AddSeller>(
      () => AddSeller(authRepository: getIt<SellerRepository>()),
    );
  }

  if (!getIt.isRegistered<GetSeller>()) {
    getIt.registerLazySingleton<GetSeller>(
      () => GetSeller(authRepository: getIt<SellerRepository>()),
    );
  }

  if (!getIt.isRegistered<GetAllSellers>()) {
    getIt.registerLazySingleton<GetAllSellers>(
      () => GetAllSellers(authRepository: getIt<SellerRepository>()),
    );
  }

  if (!getIt.isRegistered<EditSeller>()) {
    getIt.registerLazySingleton<EditSeller>(
      () => EditSeller(authRepository: getIt<SellerRepository>()),
    );
  }

  // Cars data sources
  if (!getIt.isRegistered<CarListRemoteDataSource>()) {
    getIt.registerLazySingleton<CarListRemoteDataSource>(
      () => CarListRemoteDataSourceImpl(dio: getIt<Dio>()),
    );
  }

  if (!getIt.isRegistered<CarListLocalDataSource>()) {
    getIt.registerLazySingleton<CarListLocalDataSource>(
      () => CarListLocalDataSourceImpl(
          sharedPreferences: getIt<SharedPreferences>()),
    );
  }

  // Cars repositories
  if (!getIt.isRegistered<CarListRepository>()) {
    getIt.registerLazySingleton<CarListRepository>(
      () => CarListRepositoryImpl(
        remoteDataSource: getIt<CarListRemoteDataSource>(),
        localDataSource: getIt<CarListLocalDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
  }

  // Cars use cases
  if (!getIt.isRegistered<GetCarList>()) {
    getIt.registerLazySingleton<GetCarList>(
      () => GetCarList(carListRepository: getIt<CarListRepository>()),
    );
  }

  // My Shop data sources
  if (!getIt.isRegistered<CarDataRemoteDataSource>()) {
    getIt.registerLazySingleton<CarDataRemoteDataSource>(
      () => CarDataRemoteDataSourceImpl(dio: getIt<Dio>()),
    );
  }

  // My Shop repositories
  if (!getIt.isRegistered<CarDataRepository>()) {
    getIt.registerLazySingleton<CarDataRepository>(
      () => CarDataRepositoryImpl(
        remoteDataSource: getIt<CarDataRemoteDataSource>(),
        networkInfo: getIt<NetworkInfo>(),
      ),
    );
  }

  // My Shop use cases
  if (!getIt.isRegistered<PostCarData>()) {
    getIt.registerLazySingleton<PostCarData>(
      () => PostCarData(carDataRepository: getIt<CarDataRepository>()),
    );
  }

  if (!getIt.isRegistered<EditCarData>()) {
    getIt.registerLazySingleton<EditCarData>(
      () => EditCarData(carDataRepository: getIt<CarDataRepository>()),
    );
  }

  if (!getIt.isRegistered<DeleteCarData>()) {
    getIt.registerLazySingleton<DeleteCarData>(
      () => DeleteCarData(carDataRepository: getIt<CarDataRepository>()),
    );
  }

  // Rental data sources
  if (!getIt.isRegistered<RentalRemoteDataSource>()) {
    getIt.registerLazySingleton<RentalRemoteDataSource>(
      () => RentalRemoteDataSourceImpl(getIt<Dio>()),
    );
  }

  // Rental repositories
  if (!getIt.isRegistered<RentalRepository>()) {
    getIt.registerLazySingleton<RentalRepository>(
      () => RentalRepositoryImpl(getIt<RentalRemoteDataSource>()),
    );
  }
  // Sale repositories
  if (!getIt.isRegistered<SaleRepository>()) {
    getIt.registerLazySingleton<SaleRepository>(
      () => SaleRepositoryImpl(getIt<SaleRemoteDataSource>()),
    );
  }

  // Rental use cases
  if (!getIt.isRegistered<CreateRentalUseCase>()) {
    getIt.registerLazySingleton<CreateRentalUseCase>(
      () => CreateRentalUseCase(getIt<RentalRepository>()),
    );
  }
  if (!getIt.isRegistered<GetSellerRentalsUseCase>()) {
    getIt.registerLazySingleton<GetSellerRentalsUseCase>(
      () => GetSellerRentalsUseCase(getIt<RentalRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAllRentalsUseCase>()) {
    getIt.registerLazySingleton<GetAllRentalsUseCase>(
      () => GetAllRentalsUseCase(getIt<RentalRepository>()),
    );
  }
  if (!getIt.isRegistered<UpdateRentalUseCase>()) {
    getIt.registerLazySingleton<UpdateRentalUseCase>(
      () => UpdateRentalUseCase(getIt<RentalRepository>()),
    );
  }
  if (!getIt.isRegistered<DeleteRentalUseCase>()) {
    getIt.registerLazySingleton<DeleteRentalUseCase>(
      () => DeleteRentalUseCase(getIt<RentalRepository>()),
    );
  }

  // Rental providers
  if (!getIt.isRegistered<RentalProvider>()) {
    getIt.registerFactory<RentalProvider>(
      () => RentalProvider(
        createRentalUseCase: getIt<CreateRentalUseCase>(),
        getSellerRentalsUseCase: getIt<GetSellerRentalsUseCase>(),
        getAllRentalsUseCase: getIt<GetAllRentalsUseCase>(),
        deleteRentalUseCase: getIt<DeleteRentalUseCase>(),
        updateRentalUseCase: getIt<UpdateRentalUseCase>(),
      ),
    );
  }

  // Sale use cases
  if (!getIt.isRegistered<CreateSaleUseCase>()) {
    getIt.registerLazySingleton<CreateSaleUseCase>(
      () => CreateSaleUseCase(getIt<SaleRepository>()),
    );
  }
  if (!getIt.isRegistered<GetSaleByIdUseCase>()) {
    getIt.registerLazySingleton<GetSaleByIdUseCase>(
      () => GetSaleByIdUseCase(getIt<SaleRepository>()),
    );
  }
  if (!getIt.isRegistered<GetAllSalesUseCase>()) {
    getIt.registerLazySingleton<GetAllSalesUseCase>(
      () => GetAllSalesUseCase(getIt<SaleRepository>()),
    );
  }
  if (!getIt.isRegistered<UpdateSaleUseCase>()) {
    getIt.registerLazySingleton<UpdateSaleUseCase>(
      () => UpdateSaleUseCase(getIt<SaleRepository>()),
    );
  }
  if (!getIt.isRegistered<DeleteSaleUseCase>()) {
    getIt.registerLazySingleton<DeleteSaleUseCase>(
      () => DeleteSaleUseCase(getIt<SaleRepository>()),
    );
  }
  if (!getIt.isRegistered<DeleteSaleUseCase>()) {
    getIt.registerLazySingleton<DeleteSaleUseCase>(
      () => DeleteSaleUseCase(getIt<SaleRepository>()),
    );
  }

  // Sale providers
  if (!getIt.isRegistered<SaleProvider>()) {
    getIt.registerFactory<SaleProvider>(
      () => SaleProvider(
        createSaleUseCase: getIt<CreateSaleUseCase>(),
        getSaleByIdUseCase: getIt<GetSaleByIdUseCase>(),
        getAllSalesUseCase: getIt<GetAllSalesUseCase>(),
        deleteSaleUseCase: getIt<DeleteSaleUseCase>(),
        updateSaleUseCase: getIt<UpdateSaleUseCase>(),
      ),
    );
  }
  if (!getIt.isRegistered<SaleRemoteDataSource>()) {
    getIt.registerLazySingleton<SaleRemoteDataSource>(
      () => SaleRemoteDataSourceImpl(getIt<Dio>()),
    );
  }
}
