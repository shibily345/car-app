import 'dart:convert';
import 'dart:io';

import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ConfirmationForm extends StatelessWidget {
  final CarModel car;
  const ConfirmationForm({super.key, required this.car});

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    return ListView(
      children: [
        60.0.spaceX,
        const Padding(
          padding: EdgeInsets.only(left: 20.0),
          child: Ctext(
            'Images:',
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(18.0),
          child: GridView.builder(
            shrinkWrap: true,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              mainAxisSpacing: 5,
              crossAxisCount: 2,
            ),
            itemCount: car.images?.length ?? 0,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    image: DecorationImage(
                        image: FileImage(File(car.images![index])))),
                height: 120,
                width: 120,
                child: IconButton(
                    onPressed: () {
                      // Remove image from the list
                      final updatedImages = List<String>.from(car.images ?? []);
                      updatedImages.removeAt(index);
                      final updatedCar = CarModel(
                        id: car.id ?? '',
                        title: car.title ?? '',
                        make: car.make ?? '',
                        model: car.model ?? '',
                        year: car.year ?? DateTime.now().year,
                        color: car.color ?? '',
                        price: car.price ?? 0.0,
                        mileage: car.mileage ?? 0,
                        description: car.description ?? '',
                        features: car.features ?? [],
                        images: updatedImages,
                        location: car.location ?? '',
                        transmission: car.transmission ?? '',
                        fuel: car.fuel ?? '',
                        sellerId: car.sellerId ?? '',
                        createdAt: car.createdAt ?? DateTime.now(),
                        updatedAt: car.updatedAt ?? DateTime.now(),
                      );
                      context
                          .read<CarCreateProvider>()
                          .updateCarData(updatedCar);
                    },
                    icon: const Icon(Icons.delete)),
              );
            },
          ),
        ),
        const ThickDevider(),
        SubSec(
          title: "Price ",
          name: (car.price ?? 0.0).toString(),
        ),

        SubSec(
          title: "Make ",
          name: car.make ?? '',
        ),

        SubSec(
          title: "Model ",
          name: car.model ?? '',
        ),

        SubSec(
          title: "Year ",
          name: (car.year ?? DateTime.now().year).toString(),
        ),

        SubSec(
          title: "Milage ",
          name: (car.mileage ?? 0).toString(),
        ),

        SubSec(
          title: "Transmission ",
          name: car.transmission ?? '',
        ),

        SubSec(
          title: "Fuel ",
          name: car.fuel ?? '',
        ),

        SubSec(
          title: "Location ",
          name: car.location ?? '',
        ),

        const ThickDevider(),
        DetailsSec(
          th: th,
          details: car.features ?? [],
        ),
        const ThickDevider(),
        DescSec(
          th: th,
          description: car.description ?? '',
        ),
        Consumer2<CarCreateProvider, UserProvider>(
            builder: (context, cp, up, _) {
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: OutlineButton(
              icon: Icons.done,
              label: "Confirm",
              onPressed: () async {
                List<String> images =
                    await cp.uploadImages(cp.carData?.images ?? []);

                print('New images: $images');
                cp.eitherFailureOrCarData(
                    context: context,
                    value: CarModel(
                        id: const Uuid().v7(),
                        title:
                            "${car.make ?? ''} ${car.model ?? ''} ${car.year ?? DateTime.now().year} ${car.location ?? ''}",
                        make: car.make ?? '',
                        model: car.model ?? '',
                        year: car.year ?? DateTime.now().year,
                        color: car.color ?? '',
                        price: car.price ?? 0.0,
                        mileage: car.mileage ?? 0,
                        description: car.description ?? '',
                        features: car.features ?? [],
                        images: car.images ?? [],
                        location: car.location ?? '',
                        transmission: car.transmission ?? '',
                        fuel: car.fuel ?? '',
                        sellerId: up.firebaseUser?.uid ?? '',
                        createdAt: car.createdAt ?? DateTime.now(),
                        updatedAt: DateTime.now()));
                Navigator.popAndPushNamed(context, "/");
              },
            ),
          );
        })
        // const ThickDevider(),
        // const LocationSec(),
      ],
    );
  }
}

class ImageUploadForm extends StatelessWidget {
  const ImageUploadForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Container(
        margin: const EdgeInsets.all(15),
        child: Column(
          children: [
            const Icon(
              Icons.drive_folder_upload,
              size: 80,
            ),
            GestureDetector(
              onTap: () {
                cp.pickImage();
              },
              child: const SpContainer(
                height: 60,
                width: 200,
                child: Center(child: Ctext('Upload Images')),
              ),
            ),
            Expanded(
              child: GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  mainAxisSpacing: 5,
                  crossAxisCount: 2,
                ),
                itemCount: cp.carData?.images?.length ?? 0,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        image: DecorationImage(
                            image:
                                FileImage(File(cp.carData!.images![index])))),
                    height: 120,
                    width: 120,
                    child: IconButton(
                        onPressed: () {
                          // Remove image from the list
                          final updatedImages =
                              List<String>.from(cp.carData!.images ?? []);
                          updatedImages.removeAt(index);
                          final updatedCar = CarModel(
                            id: cp.carData!.id ?? '',
                            title: cp.carData!.title ?? '',
                            make: cp.carData!.make ?? '',
                            model: cp.carData!.model ?? '',
                            year: cp.carData!.year ?? DateTime.now().year,
                            color: cp.carData!.color ?? '',
                            price: cp.carData!.price ?? 0.0,
                            mileage: cp.carData!.mileage ?? 0,
                            description: cp.carData!.description ?? '',
                            features: cp.carData!.features ?? [],
                            images: updatedImages,
                            location: cp.carData!.location ?? '',
                            transmission: cp.carData!.transmission ?? '',
                            fuel: cp.carData!.fuel ?? '',
                            sellerId: cp.carData!.sellerId ?? '',
                            createdAt: cp.carData!.createdAt ?? DateTime.now(),
                            updatedAt: cp.carData!.updatedAt ?? DateTime.now(),
                          );
                          cp.updateCarData(updatedCar);
                        },
                        icon: const Icon(Icons.delete)),
                  );
                },
              ),
            )
          ],
        ),
      );
    });
  }
}

class LocationPriceForm extends StatelessWidget {
  const LocationPriceForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(15),
      height: 400,
      child: Column(
        children: [
          CTextField(
            labelText: 'Location',
            onChanged: (value) {
              final cp = context.read<CarCreateProvider>();
              if (cp.carData != null) {
                final updatedCar = CarModel(
                  id: cp.carData!.id ?? '',
                  title: cp.carData!.title ?? '',
                  make: cp.carData!.make ?? '',
                  model: cp.carData!.model ?? '',
                  year: cp.carData!.year ?? DateTime.now().year,
                  color: cp.carData!.color ?? '',
                  price: cp.carData!.price ?? 0.0,
                  mileage: cp.carData!.mileage ?? 0,
                  description: cp.carData!.description ?? '',
                  features: cp.carData!.features ?? [],
                  images: cp.carData!.images ?? [],
                  location: value,
                  transmission: cp.carData!.transmission ?? '',
                  fuel: cp.carData!.fuel ?? '',
                  sellerId: cp.carData!.sellerId ?? '',
                  createdAt: cp.carData!.createdAt ?? DateTime.now(),
                  updatedAt: cp.carData!.updatedAt ?? DateTime.now(),
                );
                cp.updateCarData(updatedCar);
              }
            },
          ),
          CTextField(
            keyboardType: const TextInputType.numberWithOptions(),
            labelText: 'Price',
            onChanged: (value) {
              final cp = context.read<CarCreateProvider>();
              if (cp.carData != null) {
                final updatedCar = CarModel(
                  id: cp.carData!.id ?? '',
                  title: cp.carData!.title ?? '',
                  make: cp.carData!.make ?? '',
                  model: cp.carData!.model ?? '',
                  year: cp.carData!.year ?? DateTime.now().year,
                  color: cp.carData!.color ?? '',
                  price: double.tryParse(value) ?? 0.0,
                  mileage: cp.carData!.mileage ?? 0,
                  description: cp.carData!.description ?? '',
                  features: cp.carData!.features ?? [],
                  images: cp.carData!.images ?? [],
                  location: cp.carData!.location ?? '',
                  transmission: cp.carData!.transmission ?? '',
                  fuel: cp.carData!.fuel ?? '',
                  sellerId: cp.carData!.sellerId ?? '',
                  createdAt: cp.carData!.createdAt ?? DateTime.now(),
                  updatedAt: cp.carData!.updatedAt ?? DateTime.now(),
                );
                cp.updateCarData(updatedCar);
              }
            },
          ),
        ],
      ),
    );
  }
}

class CarDetailForm extends StatelessWidget {
  final PageController pageController;
  final CarCreateProvider cp;

  const CarDetailForm({
    super.key,
    required this.cp,
    required this.pageController,
  });

  void _validateAndProceed(BuildContext context) {
    final carData = cp.carData;
    if (carData == null) return;

    if ((carData.make ?? '').isEmpty) {
      _showErrorDialog(context, 'Please select a car make.');
      return;
    }
    if ((carData.model ?? '').isEmpty) {
      _showErrorDialog(context, 'Please select a car model.');
      return;
    }
    if ((carData.mileage ?? 0) <= 0) {
      _showErrorDialog(context, 'Please enter a valid mileage.');
      return;
    }
    if ((carData.description ?? '').isEmpty) {
      _showErrorDialog(context, 'Please provide a description.');
      return;
    }
    if ((carData.transmission ?? '').isEmpty) {
      _showErrorDialog(context, 'Please select a transmission type.');
      return;
    }
    if ((carData.fuel ?? '').isEmpty) {
      _showErrorDialog(context, 'Please select a fuel type.');
      return;
    }

    pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  void _showErrorDialog(BuildContext context, String message) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Validation Error'),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15),
      child: ListView(
        children: [
          const Text(
            'Enter Car Details',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 8),
          const Text(
            'Provide detailed information about the car you are selling.',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          const SizedBox(height: 20),
          FutureBuilder<String>(
            future: DefaultAssetBundle.of(context)
                .loadString('assets/data/vehicles.json'),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(child: CircularProgressIndicator());
              }
              if (snapshot.hasError || !snapshot.hasData) {
                return const Text('Error loading vehicle data');
              }

              final List<dynamic> jsonData =
                  json.decode(snapshot.data!)['brands'];
              final List<String> brands = jsonData
                  .map((brandData) => brandData['brand'] as String)
                  .toList();

              return Column(
                children: [
                  _buildAutocomplete(
                    label: 'Make',
                    hint: 'Enter your vehicle\'s brand',
                    options: brands,
                    onSelected: (value) {
                      final updatedCar = CarModel(
                        id: cp.carData?.id ?? '',
                        title: cp.carData?.title ?? '',
                        make: value,
                        model: cp.carData?.model ?? '',
                        year: cp.carData?.year ?? DateTime.now().year,
                        color: cp.carData?.color ?? '',
                        price: cp.carData?.price ?? 0.0,
                        mileage: cp.carData?.mileage ?? 0,
                        description: cp.carData?.description ?? '',
                        features: cp.carData?.features ?? [],
                        images: cp.carData?.images ?? [],
                        location: cp.carData?.location ?? '',
                        transmission: cp.carData?.transmission ?? '',
                        fuel: cp.carData?.fuel ?? '',
                        sellerId: cp.carData?.sellerId ?? '',
                        createdAt: cp.carData?.createdAt ?? DateTime.now(),
                        updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
                      );
                      cp.updateCarData(updatedCar);
                    },
                  ),
                  _buildModelAutocomplete(jsonData),
                ],
              );
            },
          ),
          const SizedBox(height: 20),
          _buildYearSelector(context),
          _buildTextField(
            label: 'KM Driven',
            hint: '13000+',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              final updatedCar = CarModel(
                id: cp.carData?.id ?? '',
                title: cp.carData?.title ?? '',
                make: cp.carData?.make ?? '',
                model: cp.carData?.model ?? '',
                year: cp.carData?.year ?? DateTime.now().year,
                color: cp.carData?.color ?? '',
                price: cp.carData?.price ?? 0.0,
                mileage: int.tryParse(value) ?? 0,
                description: cp.carData?.description ?? '',
                features: cp.carData?.features ?? [],
                images: cp.carData?.images ?? [],
                location: cp.carData?.location ?? '',
                transmission: cp.carData?.transmission ?? '',
                fuel: cp.carData?.fuel ?? '',
                sellerId: cp.carData?.sellerId ?? '',
                createdAt: cp.carData?.createdAt ?? DateTime.now(),
                updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
              );
              cp.updateCarData(updatedCar);
            },
          ),
          _buildTextField(
            label: 'Description',
            hint: 'A detailed description',
            keyboardType: TextInputType.multiline,
            onChanged: (value) {
              final updatedCar = CarModel(
                id: cp.carData?.id ?? '',
                title: cp.carData?.title ?? '',
                make: cp.carData?.make ?? '',
                model: cp.carData?.model ?? '',
                year: cp.carData?.year ?? DateTime.now().year,
                color: cp.carData?.color ?? '',
                price: cp.carData?.price ?? 0.0,
                mileage: cp.carData?.mileage ?? 0,
                description: value,
                features: cp.carData?.features ?? [],
                images: cp.carData?.images ?? [],
                location: cp.carData?.location ?? '',
                transmission: cp.carData?.transmission ?? '',
                fuel: cp.carData?.fuel ?? '',
                sellerId: cp.carData?.sellerId ?? '',
                createdAt: cp.carData?.createdAt ?? DateTime.now(),
                updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
              );
              cp.updateCarData(updatedCar);
            },
          ),
          _buildDropdown(
            label: 'Transmission',
            items: const ['Manual', 'Automatic', 'Hybrid'],
            onChanged: (value) {
              final updatedCar = CarModel(
                id: cp.carData?.id ?? '',
                title: cp.carData?.title ?? '',
                make: cp.carData?.make ?? '',
                model: cp.carData?.model ?? '',
                year: cp.carData?.year ?? DateTime.now().year,
                color: cp.carData?.color ?? '',
                price: cp.carData?.price ?? 0.0,
                mileage: cp.carData?.mileage ?? 0,
                description: cp.carData?.description ?? '',
                features: cp.carData?.features ?? [],
                images: cp.carData?.images ?? [],
                location: cp.carData?.location ?? '',
                transmission: value,
                fuel: cp.carData?.fuel ?? '',
                sellerId: cp.carData?.sellerId ?? '',
                createdAt: cp.carData?.createdAt ?? DateTime.now(),
                updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
              );
              cp.updateCarData(updatedCar);
            },
          ),
          _buildDropdown(
            label: 'Fuel',
            items: const ['Diesel', 'Petrol', 'Electric', 'Hybrid', 'CNG'],
            onChanged: (value) {
              final updatedCar = CarModel(
                id: cp.carData?.id ?? '',
                title: cp.carData?.title ?? '',
                make: cp.carData?.make ?? '',
                model: cp.carData?.model ?? '',
                year: cp.carData?.year ?? DateTime.now().year,
                color: cp.carData?.color ?? '',
                price: cp.carData?.price ?? 0.0,
                mileage: cp.carData?.mileage ?? 0,
                description: cp.carData?.description ?? '',
                features: cp.carData?.features ?? [],
                images: cp.carData?.images ?? [],
                location: cp.carData?.location ?? '',
                transmission: cp.carData?.transmission ?? '',
                fuel: value,
                sellerId: cp.carData?.sellerId ?? '',
                createdAt: cp.carData?.createdAt ?? DateTime.now(),
                updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
              );
              cp.updateCarData(updatedCar);
            },
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () => _validateAndProceed(context),
            child: const Text('Confirm and Next'),
          ),
        ],
      ),
    );
  }

  Widget _buildAutocomplete({
    required String label,
    required String hint,
    required List<String> options,
    required Function(String) onSelected,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        if (textEditingValue.text.isEmpty) {
          return const Iterable<String>.empty();
        }
        return options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: onSelected,
      fieldViewBuilder: (context, controller, focusNode, onFieldSubmitted) {
        return TextField(
          controller: controller,
          focusNode: focusNode,
          decoration: InputDecoration(labelText: label, hintText: hint),
        );
      },
    );
  }

  Widget _buildModelAutocomplete(List<dynamic> jsonData) {
    List<String> models = (cp.carData?.make ?? '').isNotEmpty
        ? jsonData
            .firstWhere(
              (brandData) => brandData['brand'] == cp.carData?.make,
              orElse: () => {'models': []},
            )['models']
            .cast<String>()
        : [];

    return _buildAutocomplete(
      label: 'Model',
      hint: 'Enter car model',
      options: models,
      onSelected: (value) {
        final updatedCar = CarModel(
          id: cp.carData?.id ?? '',
          title: cp.carData?.title ?? '',
          make: cp.carData?.make ?? '',
          model: value,
          year: cp.carData?.year ?? DateTime.now().year,
          color: cp.carData?.color ?? '',
          price: cp.carData?.price ?? 0.0,
          mileage: cp.carData?.mileage ?? 0,
          description: cp.carData?.description ?? '',
          features: cp.carData?.features ?? [],
          images: cp.carData?.images ?? [],
          location: cp.carData?.location ?? '',
          transmission: cp.carData?.transmission ?? '',
          fuel: cp.carData?.fuel ?? '',
          sellerId: cp.carData?.sellerId ?? '',
          createdAt: cp.carData?.createdAt ?? DateTime.now(),
          updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
        );
        cp.updateCarData(updatedCar);
      },
    );
  }

  Widget _buildYearSelector(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        final selectedYear = await showDialog<int>(
          context: context,
          builder: (BuildContext context) {
            final currentYear = DateTime.now().year;
            return AlertDialog(
              title: const Text('Select Year'),
              content: SizedBox(
                width: double.maxFinite,
                height: 300,
                child: ListView.builder(
                  itemCount: 50,
                  itemBuilder: (context, index) {
                    final year = currentYear - index;
                    return ListTile(
                      title: Text(year.toString()),
                      onTap: () => Navigator.pop(context, year),
                    );
                  },
                ),
              ),
            );
          },
        );

        if (selectedYear != null) {
          final updatedCar = CarModel(
            id: cp.carData?.id ?? '',
            title: cp.carData?.title ?? '',
            make: cp.carData?.make ?? '',
            model: cp.carData?.model ?? '',
            year: selectedYear,
            color: cp.carData?.color ?? '',
            price: cp.carData?.price ?? 0.0,
            mileage: cp.carData?.mileage ?? 0,
            description: cp.carData?.description ?? '',
            features: cp.carData?.features ?? [],
            images: cp.carData?.images ?? [],
            location: cp.carData?.location ?? '',
            transmission: cp.carData?.transmission ?? '',
            fuel: cp.carData?.fuel ?? '',
            sellerId: cp.carData?.sellerId ?? '',
            createdAt: cp.carData?.createdAt ?? DateTime.now(),
            updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
          );
          cp.updateCarData(updatedCar);
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label: 'Year',
          hint: '2016*',
          controller: TextEditingController(
            text: (cp.carData?.year ?? DateTime.now().year).toString(),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField({
    required String label,
    required String hint,
    TextInputType keyboardType = TextInputType.text,
    TextEditingController? controller,
    Function(String)? onChanged,
  }) {
    return TextField(
      controller: controller,
      keyboardType: keyboardType,
      decoration: InputDecoration(labelText: label, hintText: hint),
      onChanged: onChanged,
    );
  }

  Widget _buildDropdown({
    required String label,
    required List<String> items,
    required Function(String) onChanged,
  }) {
    return DropdownButtonFormField<String>(
      decoration: InputDecoration(labelText: label),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: (value) {
        onChanged(value!);
      },
    );
  }
}

class FeturesForm extends StatelessWidget {
  const FeturesForm({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    TextEditingController fc = TextEditingController();
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Container(
        margin: const EdgeInsets.all(15),
        height: 400,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Wrap(
                spacing: 8.0, // gap between adjacent chips
                runSpacing: 4.0, // gap between lines
                children: List<Widget>.generate(
                    cp.carData?.features?.length ?? 0, (int index) {
                  return Chip(
                    onDeleted: () {
                      final updatedFeatures =
                          List<String>.from(cp.carData?.features ?? []);
                      updatedFeatures.removeAt(index);
                      final updatedCar = CarModel(
                        id: cp.carData?.id ?? '',
                        title: cp.carData?.title ?? '',
                        make: cp.carData?.make ?? '',
                        model: cp.carData?.model ?? '',
                        year: cp.carData?.year ?? DateTime.now().year,
                        color: cp.carData?.color ?? '',
                        price: cp.carData?.price ?? 0.0,
                        mileage: cp.carData?.mileage ?? 0,
                        description: cp.carData?.description ?? '',
                        features: updatedFeatures,
                        images: cp.carData?.images ?? [],
                        location: cp.carData?.location ?? '',
                        transmission: cp.carData?.transmission ?? '',
                        fuel: cp.carData?.fuel ?? '',
                        sellerId: cp.carData?.sellerId ?? '',
                        createdAt: cp.carData?.createdAt ?? DateTime.now(),
                        updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
                      );
                      cp.updateCarData(updatedCar);
                    },
                    label: Text(cp.carData?.features?[index] ?? ''),
                    backgroundColor: Colors.lightBlue[100],
                  );
                }),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                SizedBox(
                    width: 180,
                    child: CTextField(
                      controller: fc,
                      labelText: 'Add Feture',
                      hintText: 'Panoramic Roof',
                    )),
                FloatingActionButton(
                  heroTag: "addFeatureWidgetFAB",
                  onPressed: () {
                    if (fc.text.isNotEmpty) {
                      final updatedFeatures =
                          List<String>.from(cp.carData?.features ?? []);
                      updatedFeatures.add(fc.text);
                      final updatedCar = CarModel(
                        id: cp.carData?.id ?? '',
                        title: cp.carData?.title ?? '',
                        make: cp.carData?.make ?? '',
                        model: cp.carData?.model ?? '',
                        year: cp.carData?.year ?? DateTime.now().year,
                        color: cp.carData?.color ?? '',
                        price: cp.carData?.price ?? 0.0,
                        mileage: cp.carData?.mileage ?? 0,
                        description: cp.carData?.description ?? '',
                        features: updatedFeatures,
                        images: cp.carData?.images ?? [],
                        location: cp.carData?.location ?? '',
                        transmission: cp.carData?.transmission ?? '',
                        fuel: cp.carData?.fuel ?? '',
                        sellerId: cp.carData?.sellerId ?? '',
                        createdAt: cp.carData?.createdAt ?? DateTime.now(),
                        updatedAt: cp.carData?.updatedAt ?? DateTime.now(),
                      );
                      cp.updateCarData(updatedCar);
                      fc.clear();
                    }
                  },
                  elevation: 0,
                  child: const Icon(Icons.add),
                )
              ],
            ),
          ],
        ),
      );
    });
  }
}
