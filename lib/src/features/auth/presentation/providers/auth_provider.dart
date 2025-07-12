import 'dart:developer';

import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/apple_sign_in.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/email_register.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/email_sign_in.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/auth/google_sign_in%20copy.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/auth/auth_local_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/auth/auth_remote_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:car_app_beta/src/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:http/http.dart' as context;
import 'package:shared_preferences/shared_preferences.dart';

class AuthenticationProvider extends ChangeNotifier {
  UserModel? auth;
  Failure? failure;
  AuthenticationProvider({
    this.auth,
    this.failure,
  });

  Future<Either<Failure, UserModel>> eitherFailureOrAuth() async {
    EasyLoading.show(status: 'Sign in with google...');
    log("with google...............");
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
        log("failed with google...............");

        EasyLoading.dismiss();
        auth = null;
        failure = newFailure;
        // EasyLoading.dismiss();

        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        EasyLoading.dismiss();

        notifyListeners();
      },
    );
    EasyLoading.dismiss();
    return failureOrAuth;
  }

  Future<Either<Failure, UserModel>> eitherFailureOrAuthWithEmail(
      String email, String password) async {
    EasyLoading.show(status: 'Sign in with Email and pass...');
    log("with google...............");
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth =
        await EmailSignIn(authRepository: repository).call(email, password);

    failureOrAuth.fold(
      (Failure newFailure) {
        log("failed with email and password...............");

        EasyLoading.dismiss();
        auth = null;
        failure = newFailure;
        // EasyLoading.dismiss();

        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        EasyLoading.dismiss();

        notifyListeners();
      },
    );
    EasyLoading.dismiss();
    return failureOrAuth;
  }

  Future<Either<Failure, UserModel>> eitherFailureOrCreateWithEmail(
      String email, String password) async {
    EasyLoading.show(status: 'Create account with Email and pass...');
    log("Creating account with Email and Password.. -- $email .... $password.");
    AuthRepositoryImpl repository = AuthRepositoryImpl(
      remoteDataSource: AuthRemoteDataSourceImpl(),
      localDataSource: AuthLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth = await RegisterWithEmail(authRepository: repository)
        .call(email, password);

    failureOrAuth.fold(
      (Failure newFailure) {
        log("failed with email and password...............");

        EasyLoading.dismiss();
        auth = null;
        failure = newFailure;
        // EasyLoading.dismiss();

        notifyListeners();
      },
      (UserModel newAuth) {
        auth = newAuth;
        failure = null;
        EasyLoading.dismiss();

        notifyListeners();
      },
    );
    EasyLoading.dismiss();
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

        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<void> logout(BuildContext context) async {
    try {
      EasyLoading.show();
      await FirebaseAuth.instance.signOut().then((u) {
        
        Navigator.pushReplacementNamed(context, "/");
      });
      EasyLoading.dismiss();
    } catch (e) {
      EasyLoading.dismiss();

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
}
