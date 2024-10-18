import 'dart:convert';
import 'package:car_app_beta/core/errors/exceptions.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:shared_preferences/shared_preferences.dart';

abstract class SellerLocalDataSource {
  Future<void>? cacheSeller(SellerModel? sellerToCache);

  Future<SellerModel> getLastSeller();
}

const cachedSeller = 'CACHED_SELLER';

class SellerLocalDataSourceImpl implements SellerLocalDataSource {
  final SharedPreferences sharedPreferences;

  SellerLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<SellerModel> getLastSeller() {
    final jsonString = sharedPreferences.getString(cachedSeller);

    if (jsonString != null) {
      return Future.value(SellerModel.fromJson(json.decode(jsonString)));
    } else {
      throw CacheException();
    }
  }

  @override
  Future<void>? cacheSeller(SellerModel? sellerToCache) async {
    if (sellerToCache != null) {
      sharedPreferences.setString(
        cachedSeller,
        json.encode(
          sellerToCache.toJson(),
        ),
      );
    } else {
      throw CacheException();
    }
  }
}
