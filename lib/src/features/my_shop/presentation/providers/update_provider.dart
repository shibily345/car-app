import 'dart:io';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/errors/failure.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/post_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/edit_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/business/usecases/delete_car_data.dart';
import 'package:car_app_beta/src/features/my_shop/data/datasources/car_data_remote_data_source.dart';
import 'package:car_app_beta/src/features/my_shop/data/repositories/car_list_repository_impl.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/core/service_locator.dart';
import 'package:dartz/dartz.dart';
import 'package:data_connection_checker_tv/data_connection_checker.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

class CarCreateProvider extends ChangeNotifier {
  CarModel? carData;
  XFile? _image;
  bool _hasImage = false;
  Response? response;
  Failure? failure;

  CarModel? get car => carData;
  XFile? get image => _image;
  bool get hasImage => _hasImage;

  void clearAll() {
    carData = null;
    _image = null;
    _hasImage = false;
    response = null;
    failure = null;
    notifyListeners();
  }

  void updateCarData(CarModel car) {
    carData = car;
    notifyListeners();
  }

  // Helper method to update specific fields without creating a new CarModel
  void updateCarField({
    String? make,
    String? model,
    int? year,
    String? color,
    double? price,
    int? mileage,
    String? description,
    List<String>? features,
    List<String>? images,
    String? location,
    String? transmission,
    String? fuel,
    String? type,
    String? seats,
    bool? isVerified,
    bool? isForSale,
    bool? isForRent,
  }) {
    if (carData != null) {
      carData = CarModel(
        id: carData!.id ?? '',
        title: carData!.title ?? '',
        make: make ?? carData!.make ?? '',
        model: model ?? carData!.model ?? '',
        year: year ?? carData!.year ?? DateTime.now().year,
        color: color ?? carData!.color ?? '',
        price: price ?? carData!.price ?? 0.0,
        mileage: mileage ?? carData!.mileage ?? 0,
        description: description ?? carData!.description ?? '',
        features: features ?? carData!.features ?? [],
        images: images ?? carData!.images ?? [],
        location: location ?? carData!.location ?? '',
        transmission: transmission ?? carData!.transmission ?? '',
        fuel: fuel ?? carData!.fuel ?? '',
        sellerId: carData!.sellerId ?? '',
        createdAt: carData!.createdAt ?? DateTime.now(),
        updatedAt: carData!.updatedAt ?? DateTime.now(),
        type: type ?? carData!.type ?? '',
        seats: seats ?? carData!.seats ?? '4',
        isVerified: isVerified ?? carData!.isVerified ?? false,
        isForSale: isForSale ?? carData!.isForSale ?? false,
        isForRent: isForRent ?? carData!.isForRent ?? false,
      );
      notifyListeners();
    }
  }

  void updateImageNames(List<String> imageNames) {
    if (carData != null) {
      carData = CarModel(
        id: carData!.id ?? '',
        title: carData!.title ?? '',
        make: carData!.make ?? '',
        model: carData!.model ?? '',
        year: carData!.year ?? DateTime.now().year,
        color: carData!.color ?? '',
        price: carData!.price ?? 0.0,
        mileage: carData!.mileage ?? 0,
        description: carData!.description ?? '',
        features: carData!.features ?? [],
        images: imageNames,
        location: carData!.location ?? '',
        transmission: carData!.transmission ?? '',
        fuel: carData!.fuel ?? '',
        sellerId: carData!.sellerId ?? '',
        createdAt: carData!.createdAt ?? DateTime.now(),
        updatedAt: carData!.updatedAt ?? DateTime.now(),
        type: carData!.type ?? '',
        seats: carData!.seats ?? '4',
        isVerified: carData!.isVerified ?? false,
        isForSale: carData!.isForSale ?? false,
        isForRent: carData!.isForRent ?? false,
      );
      notifyListeners();
    }
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
      if (carData != null) {
        final updatedImages = List<String>.from(carData!.images ?? [])
          ..add(croppedFile.path);
        carData = CarModel(
          id: carData!.id ?? '',
          title: carData!.title ?? '',
          make: carData!.make ?? '',
          model: carData!.model ?? '',
          year: carData!.year ?? DateTime.now().year,
          color: carData!.color ?? '',
          price: carData!.price ?? 0.0,
          mileage: carData!.mileage ?? 0,
          description: carData!.description ?? '',
          features: carData!.features ?? [],
          images: updatedImages,
          location: carData!.location ?? '',
          type: carData!.type ?? '',
          seats: carData!.seats ?? '4',
          transmission: carData!.transmission ?? '',
          fuel: carData!.fuel ?? '',
          sellerId: carData!.sellerId ?? '',
          createdAt: carData!.createdAt ?? DateTime.now(),
          updatedAt: carData!.updatedAt ?? DateTime.now(),
        );
      }
      debugPrint(
          "..........          ${croppedFile.path}          ........................");
      _hasImage = true;
      notifyListeners();
      // reload();
    }
  }

  Future<void> uploadImage(XFile imageFile) async {
    String fileName = imageFile.path;

    FormData formData = FormData.fromMap({
      "image": await MultipartFile.fromFile(imageFile.path, filename: fileName),
    });

    try {
      // Use the Dio instance from service locator
      final dio = getIt<Dio>();
      Response response = await dio.post(
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
      // Use the Dio instance from service locator
      final dio = getIt<Dio>();

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
          Response response = await dio.post(
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
    required BuildContext context,
    required CarModel value,
  }) async {
    // Use the service locator to get the use case
    final postCarDataUseCase = getIt<PostCarData>();

    final failureOrResponse = await postCarDataUseCase.call(
      params: AddCarDataParams(data: value),
    );

    failureOrResponse.fold(
      (newFailure) {
        response = null;
        failure = newFailure;
        notifyListeners();
      },
      (newCarData) {
        Navigator.pop(context);
        response = newCarData;
        failure = null;
        notifyListeners();
      },
    );
  }

  void eitherFailureOrUpdateCarData({
    required CarModel value,
  }) async {
    // Use the service locator to get the use case
    final editCarDataUseCase = getIt<EditCarData>();

    final failureOrResponse = await editCarDataUseCase.call(
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

  Future<DataState<void>?> eitherFailureOrDeleteCarData({
    required String value,
    BuildContext? context,
  }) async {
    // Use the service locator to get the use case
    final deleteCarDataUseCase = getIt<DeleteCarData>();

    final failureOrResponse = await deleteCarDataUseCase.call(
      params: DeleteCarParams(id: value),
    );

    return failureOrResponse.fold(
      (newFailure) {
        response = null;
        failure = newFailure;
        debugPrint(
            '[CarCreateProvider] Delete failed: ${newFailure.errorMessage}');
        notifyListeners();
        // Convert Failure to DioException for DataFailed
        final dioException = DioException(
          requestOptions: RequestOptions(path: ''),
          error: newFailure.errorMessage,
          type: DioExceptionType.unknown,
        );
        return DataFailed(dioException);
      },
      (newCarData) {
        response = newCarData;
        failure = null;
        debugPrint('[CarCreateProvider] Car deleted successfully.');
        notifyListeners();
        return const DataSuccess(null);
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
