import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/apple_sign_in.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/google_sign_in.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/auth/auth_local_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/auth/auth_remote_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:car_app_beta/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  UserModel? auth;
  Failure? failure;
  AuthenticationProvider({
    this.auth,
    this.failure,
  });
  User? _firebaseUser;

  User? get firebaseUser => _firebaseUser;
  Future<Either<Failure, UserModel>> eitherFailureOrAuth() async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth = await GoogleSignIN(authRepository: repository).call();

    failureOrAuth.fold(
      (Failure newFailure) {
        auth = null;
        failure = newFailure;
        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        _firebaseUser = FirebaseAuth.instance.currentUser;
        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<Either<Failure, UserModel>> eitherFailureOrAuthWithApple() async {
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth = await AppleSignIn(authRepository: repository).call();

    failureOrAuth.fold(
      (Failure newFailure) {
        auth = null;
        failure = newFailure;
        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        _firebaseUser = FirebaseAuth.instance.currentUser;

        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<void> logout(BuildContext context) async {
    try {
      await FirebaseAuth.instance.signOut().then((u) {
        Navigator.pushReplacementNamed(context, "/");
      });
    } catch (e) {
      debugPrint('Error logging out: $e');
    }
  }

  Future<bool> checkSeller(String uid) async {
    try {
      // Make the POST request
      Response response = await Dio().post(
        "${Ac.baseUrl}/api/seller/check",
        data: {
          "uid": uid,
        },
      );

      // Check if the email exists
      if (response.statusCode == 200) {
        return response.data['exists'];
      } else {
        print("Error: ${response.statusCode}");
        return false;
      }
    } catch (e) {
      print("Error: $e");
      return false;
    }
  }

  void updateUser(User user) {
    _firebaseUser = user;
    notifyListeners();
  }
}
