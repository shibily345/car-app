import 'dart:io';

import 'package:car_app_beta/core/connection/network_info.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/delete_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/edit_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/post_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/data/datasources/car_data_remote_data_source.dart';
import 'package:car_app_beta/src/features/my_shop/data/repositories/car_list_repository_impl.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CarUpdateModel {
  String id;
  String title;
  String make;
  String model;
  int year;
  String color;
  double price;
  int mileage;
  String description;
  List<String> features;
  List<String> images;
  String location;
  String transmission;
  String fuel;
  String sellerId;
  DateTime createdAt;
  DateTime updatedAt;

  CarUpdateModel({
    required this.id,
    required this.title,
    required this.make,
    required this.model,
    required this.year,
    required this.color,
    required this.price,
    required this.mileage,
    required this.description,
    required this.features,
    required this.images,
    required this.location,
    required this.transmission,
    required this.fuel,
    required this.sellerId,
    required this.createdAt,
    required this.updatedAt,
  });
}

List<String> _imageNames = [];
List<String> get imageNames => _imageNames;

class CarCreateProvider with ChangeNotifier {
  CarUpdateModel? carData;

  CarCreateProvider({
    this.carData,
  });

  void updateTitle(String title) {
    carData!.title = title;
    notifyListeners();
  }

  void updateMake(String make) {
    carData!.make = make;
    notifyListeners();
  }

  void updateModel(String model) {
    carData!.model = model;
    notifyListeners();
  }

  void updateYear(int year) {
    carData!.year = year;
    notifyListeners();
  }

  void deleteFet(String fet) {
    carData!.features.remove(fet);
    notifyListeners();
  }

  void deleteImage(String img) {
    carData!.images.remove(img);
    debugPrint("$img   -----  deleted");
    notifyListeners();
  }

  void updateColor(String color) {
    carData!.color = color;
    notifyListeners();
  }

  void updatePrice(double price) {
    carData!.price = price;
    notifyListeners();
  }

  void updateMileage(int mileage) {
    carData!.mileage = mileage;
    notifyListeners();
  }

  void updateDescription(String description) {
    carData!.description = description;
    notifyListeners();
  }

  void updateFeatures(String feature) {
    carData!.features.add(feature);
    notifyListeners();
  }

  void updateImageNames(List<String> names) {
    carData!.images.addAll(names);
    carData!.images.removeWhere((image) => !image.startsWith('/uploads'));
    debugPrint("....\n\n\n\n\n\n....... carData!.images");
    notifyListeners();
  }

  void addFeature(String feature) {
    carData!.features.add(feature);

    notifyListeners();
  }

  void removeFeature(String feature) {
    carData!.features.remove(feature);
    notifyListeners();
  }

  void updateImages(List<String> images) {
    carData!.images = images;
    notifyListeners();
  }

  void addImage(String image) {
    carData!.images.add(image);
    notifyListeners();
  }

  void removeImage(String image) {
    carData!.images.remove(image);
    notifyListeners();
  }

  void updateLocation(String location) {
    carData!.location = location;
    notifyListeners();
  }

  void updateTransmission(String transmission) {
    carData!.transmission = transmission;
    notifyListeners();
  }

  void updateFuel(String fuel) {
    carData!.fuel = fuel;
    notifyListeners();
  }

  void updateSellerId(String sellerId) {
    carData!.sellerId = sellerId;
    notifyListeners();
  }

  void updateCreatedAt(DateTime createdAt) {
    carData!.createdAt = createdAt;
    notifyListeners();
  }

  void updateUpdatedAt(DateTime updatedAt) {
    carData!.updatedAt = updatedAt;
    notifyListeners();
  }

  void clearAll() {
    carData = CarUpdateModel(
      id: "",
      title: "",
      make: "",
      model: "",
      year: DateTime.now().year,
      color: "",
      price: 0.0,
      mileage: 0,
      description: "",
      features: [],
      images: [],
      location: "",
      transmission: "",
      fuel: "",
      sellerId: "",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    print("Cleared All");
    notifyListeners();
  }

  bool _hasImage = false;
  bool get hasImage => _hasImage;
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
        aspectRatio: const CropAspectRatio(ratioX: 960, ratioY: 640),
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
      carData!.images.add(croppedFile.path);
      debugPrint(
          "..........          ${croppedFile.path}          ........................");
      _hasImage = true;
      notifyListeners();
      // reload();
    }
  }

  Response? response;
  Failure? failure;

  Future<void> uploadImage(XFile imageFile) async {
    String fileName = imageFile.path;

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
    } catch (e) {
      print("Error: $e");
    }
  }

  Future<List<String>> uploadImages(List<String> imageFilePaths) async {
    List<String> filePaths = [];

    try {
      // Loop through each image file
      for (String imageFilePaths in imageFilePaths) {
        String fileName = imageFilePaths;

        // Create form data for each image
        if (!imageFilePaths.startsWith("/uploads")) {
          FormData formData = FormData.fromMap({
            "image": await MultipartFile.fromFile(imageFilePaths,
                filename: fileName),
          });

          // Upload the image
          Response response = await Dio().post(
            "${Ac.baseUrl}/upload",
            data: formData,
            options: Options(
              headers: {
                "Content-Type": "multipart/form-data",
              },
            ),
          );

          // Print the response for each image
          print("Upload Response for $imageFilePaths: ${response.data}");

          // Add the file path from the response to the list
          filePaths.add(response.data['filePath']);

          // deleteImage(imageFilePaths);
          print("\n\n\n\n\n\n\n\n\n${carData!.images}");
        }
      }
      updateImageNames(filePaths);
      // Notify listeners if needed
      notifyListeners();

      // Return the list of file paths after all uploads
      return filePaths;
    } catch (e) {
      throw Exception("Error uploading images: $e");
    }
  }

  void eitherFailureOrCarData({
    required CarModel value,
  }) async {
    CarDataRepositoryImpl repository = CarDataRepositoryImpl(
      remoteDataSource: CarDataRemoteDataSourceImpl(dio: Dio()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrResponse =
        await PostCarData(carDataRepository: repository).call(
      params: AddCarDataParams(data: value),
    );

    failureOrResponse.fold(
      (newFailure) {
        response = null;
        failure = newFailure;
        notifyListeners();
      },
      (newCarData) {
        response = newCarData;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrUpdateCarData({
    required CarModel value,
  }) async {
    CarDataRepositoryImpl repository = CarDataRepositoryImpl(
      remoteDataSource: CarDataRemoteDataSourceImpl(dio: Dio()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrResponse =
        await EditCarData(carDataRepository: repository).call(
      params: UpdateCarParams(
        id: value.id!,
        data: value,
      ),
    );

    failureOrResponse.fold(
      (newFailure) {
        response = null;
        failure = newFailure;
        notifyListeners();
      },
      (newCarData) {
        response = newCarData;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrDeleteCarData({
    required String value,
  }) async {
    CarDataRepositoryImpl repository = CarDataRepositoryImpl(
      remoteDataSource: CarDataRemoteDataSourceImpl(dio: Dio()),
      networkInfo: NetworkInfoImpl(DataConnectionChecker()),
    );

    final failureOrResponse =
        await DeleteCarData(carDataRepository: repository).call(
      params: DeleteCarParams(id: value),
    );

    failureOrResponse.fold(
      (newFailure) {
        response = null;
        failure = newFailure;
        notifyListeners();
      },
      (newCarData) {
        response = newCarData;
        failure = null;
        notifyListeners();
      },
    );
  }
}

Future<bool> checkPhotoPermission() async {
  // Check the current permission status
  var status = await Permission.photos.status;

  // If permission is not granted, request it
  if (!status.isGranted) {
    status = await Permission.photos.request();
  }

  // Handle the permission status
  if (status.isGranted) {
    // Permission is granted, proceed with accessing the photos
    print("Photo permission granted!");
    return true;
  } else if (status.isDenied) {
    // Permission was denied by the user
    print("Photo permission denied.");
    return false;
  } else if (status.isPermanentlyDenied) {
    // Permission is permanently denied, prompt the user to open app settings
    openAppSettings();
    return false;
  }
  return false;
}
