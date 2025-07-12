import 'dart:io';

import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/edit_seller.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/get_all.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/get_seller.dart';
import 'package:car_app_beta/src/features/auth/business/usecases/seller/update_seller.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_local_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/datasources/seller/seller_remote_data_source.dart';
import 'package:car_app_beta/src/features/auth/data/models/auth_model.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/data/repositories/seller_repository_impl.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserProvider extends ChangeNotifier {
  Response? res;
  Failure? failure;
  UserModel? _user;

  UserModel? get user => _user;
  User? _firebaseUser;

  User? get firebaseUser => FirebaseAuth.instance.currentUser;
  XFile _image = XFile("path");
  XFile get image => _image;

  final String _imageName = "";
  String get imageName => _imageName;

  SellerModel? _seller;

  SellerModel? get seller => _seller;

  bool _isSeller = false;
  bool get isSeller => _isSeller;

  SellerModel? _cSeller;
  SellerModel? get cSeller => _cSeller;

  List<SellerModel>? _allSellers;
  List<SellerModel>? get allSellers => _allSellers;

  bool _hasImage = false;
  bool get hasImage => _hasImage;

  List<String> _currentFavorites = [];
  List<String> get currentFavorites => _currentFavorites;

  Future<Either<Failure, Response>> eitherFailureOrUpdateSeller(
      {required AddSellerParams params}) async {
    SellerRepositoryImpl repository = SellerRepositoryImpl(
      remoteDataSource: SellerRemoteDataSourceImpl(dio: Dio()),
      localDataSource: SellerLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrAuth =
        await AddSeller(authRepository: repository).call(params: params);

    failureOrAuth.fold(
      (Failure newFailure) {
        res = null;
        failure = newFailure;
        notifyListeners();
      },
      (Response newAuth) {
        res = newAuth;
        failure = null;
        notifyListeners();
      },
    );
    return failureOrAuth;
  }

  Future<void> loadUser() async {
    if (user != null) {
      _user = UserModel(
          uid: _firebaseUser!.uid,
          email: _firebaseUser!.email!,
          displayName: _firebaseUser!.displayName);
      notifyListeners();
    }
  }

  Future<void> clearUser() async {
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('user');
    notifyListeners();
  }

  void clearAll() {
    _seller = const SellerModel(
        id: "",
        uid: "",
        email: "email",
        location: "email",
        dealershipName: "dealershipName",
        contactNumber: "contactNumber",
        displayName: "",
        photoURL: "");
  }

  Future<void> pickImage() async {
    final pickedFile = await ImagePicker()
        .pickImage(source: ImageSource.gallery)
        .then((value) {
      if (value != null) {
        _cropImage(File(value.path));
      }
    });
    debugPrint("image picked :   $pickedFile");
  }

  _cropImage(File imgFile) async {
    final croppedFile = await ImageCropper().cropImage(
        sourcePath: imgFile.path,
        aspectRatio: const CropAspectRatio(ratioX: 500, ratioY: 500),
        uiSettings: [
          AndroidUiSettings(
              toolbarTitle: "Crop Image ",
              toolbarColor: Colors.deepOrange,
              toolbarWidgetColor: Colors.white,
              initAspectRatio: CropAspectRatioPreset.original,
              lockAspectRatio: false),
          IOSUiSettings(
            title: "Image Cropper",
          )
        ]);
    if (croppedFile != null) {
      imageCache.clear();
      _image = XFile(croppedFile.path);
      _hasImage = true;
      notifyListeners();
      // reload();
    }
  }

  Future<String> uploadImage(XFile imageFile) async {
    String fileName = imageFile.name;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      Response response = await Dio().post(
        "${Ac.baseUrl}/upload",
        data: formData,
        options: Options(
          headers: {
            "Content-Type": "multipart/form-data",
          },
        ),
      );
      print("Upload Response: ${response.data}");
      notifyListeners();

      return response.data['filePath'];
      // if (response.data != null && response.data['filePath'] != null) {
      //   // Assign the file path to _imageName
      //   _imageName = response.data['filePath'];
      //   print("File Path: $_imageName");
      // } else {
      //   print("File path not found in response data");
      // }
    } catch (e) {
      throw Exception(e);
    }
  }

  void updateSeller(bool isSeller) {
    _isSeller = isSeller;
    notifyListeners();
  }

  void eitherFailureOrSeller({
    required String value,
  }) async {
    SellerRepositoryImpl repository = SellerRepositoryImpl(
      remoteDataSource: SellerRemoteDataSourceImpl(dio: Dio()),
      localDataSource: SellerLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrSeller = await GetSeller(authRepository: repository).call(
      params: GetSellerParams(id: value),
    );

    failureOrSeller.fold(
      (newFailure) {
        _cSeller = null;
        failure = newFailure;
        // debugPrint("${newFailure.errorMessage}....................");

        notifyListeners();
      },
      (newSeller) {
        _cSeller = newSeller;
        failure = null;
        // debugPrint("${newSeller.dealershipName}....................");
        notifyListeners();
      },
    );
  }

  void eitherFailureOrAllSellers() async {
    SellerRepositoryImpl repository = SellerRepositoryImpl(
      remoteDataSource: SellerRemoteDataSourceImpl(dio: Dio()),
      localDataSource: SellerLocalDataSourceImpl(
          sharedPreferences: await SharedPreferences.getInstance()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrSeller =
        await GetAllSellers(authRepository: repository).call();

    failureOrSeller.fold(
      (newFailure) {
        _cSeller = null;
        failure = newFailure;
        debugPrint(
            "${newFailure.errorMessage}..........all seller error..........");

        notifyListeners();
      },
      (newSeller) {
        _allSellers = newSeller;
        failure = null;
        debugPrint(
            "${newSeller.last.dealershipName}......got sellers..............");
        notifyListeners();
      },
    );
  }

  Future<Either<Failure, Response>> eitherFailureOrEditSeller(
      {required AddSellerParams params}) async {
    SellerRepositoryImpl repository = SellerRepositoryImpl(
      remoteDataSource: SellerRemoteDataSourceImpl(dio: Dio()),
      localDataSource: SellerLocalDataSourceImpl(
        sharedPreferences: await SharedPreferences.getInstance(),
      ),
      networkInfo: NetworkInfoImpl(
        DataConnectionChecker(),
      ),
    );

    final failureOrEdit =
        await EditSeller(authRepository: repository).call(params: params);

    failureOrEdit.fold(
      (Failure newFailure) {
        res = null;
        failure = newFailure;
        notifyListeners();
      },
      (Response resp) {
        res = resp;
        failure = null;
        debugPrint("Edited SuccessFully $resp");
        notifyListeners();
      },
    );
    return failureOrEdit;
  }

  Future<void> removeProductFromFavorites(String productId) async {
    EasyLoading.show(status: "Removing from favorites");
    currentFavorites.remove(productId);
    // Get the current Firebase user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid; // Get the user's UID

      // Reference to the user's document in Firestore
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Get the current list of favorite products
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<String> currentFavorites =
            List<String>.from(docSnapshot['favoriteProductIds'] ?? []);

        // Remove the product if it's in the list
        if (currentFavorites.contains(productId)) {
          currentFavorites.remove(productId);

          // Update the document with the new list of favorites
          await docRef.update({
            'favoriteProductIds': currentFavorites,
          });
          EasyLoading.dismiss();
          notifyListeners();
        }
      }
    }
    notifyListeners();
    EasyLoading.dismiss();
  }

  Future<List<String>> getFavoriteProductIds() async {
    // Get the current Firebase user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid; // Get the user's UID

      // Reference to the user's document in Firestore
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Fetch the document
      DocumentSnapshot docSnapshot = await docRef.get();

      // Extract the list of product IDs
      if (docSnapshot.exists && docSnapshot['favoriteProductIds'] != null) {
        _currentFavorites =
            List<String>.from(docSnapshot['favoriteProductIds']);
        notifyListeners();
        return List<String>.from(docSnapshot['favoriteProductIds']);
      }
    }
    return [];
  }

  Future<void> addProductToFavorites(String productId) async {
    EasyLoading.show(status: "Adding to favorites");
    await getFavoriteProductIds();
    currentFavorites.add(productId);

    // Get the current Firebase user
    User? currentUser = FirebaseAuth.instance.currentUser;

    if (currentUser != null) {
      String uid = currentUser.uid; // Get the user's UID

      // Reference to the user's document in Firestore
      DocumentReference docRef =
          FirebaseFirestore.instance.collection('users').doc(uid);

      // Get the current list of favorite products
      DocumentSnapshot docSnapshot = await docRef.get();

      if (docSnapshot.exists) {
        List<String> currentFavorites =
            List<String>.from(docSnapshot['favoriteProductIds'] ?? []);

        // Only add the product if it's not already in the list
        if (!currentFavorites.contains(productId)) {
          currentFavorites.add(productId);

          // Update the document with the new list of favorites
          await docRef.update({
            'favoriteProductIds': currentFavorites,
          });
        }
      } else {
        // If the document does not exist, create it with the first favorite product ID
        await docRef.set({
          'favoriteProductIds': [productId],
        });
      }
    }
    EasyLoading.dismiss();
    notifyListeners();
  }
}
