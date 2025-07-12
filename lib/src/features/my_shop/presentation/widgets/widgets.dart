import 'dart:convert';
import 'dart:io';

import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/detail_sections.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class ConfirmationForm extends StatelessWidget {
  final CarUpdateModel car;
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
            itemCount: car.images.length,
            itemBuilder: (BuildContext context, int index) {
              return Container(
                margin: const EdgeInsets.all(5),
                decoration: BoxDecoration(
                    color: Theme.of(context).splashColor,
                    image: DecorationImage(
                        image: FileImage(File(car.images[index])))),
                height: 120,
                width: 120,
                child: IconButton(
                    onPressed: () {
                      context
                          .read<CarCreateProvider>()
                          .deleteImage(car.images[index]);
                    },
                    icon: const Icon(Icons.delete)),
              );
            },
          ),
        ),
        const ThickDevider(),
        SubSec(
          title: "Price ",
          name: car.price.toString(),
        ),

        SubSec(
          title: "Make ",
          name: car.make,
        ),

        SubSec(
          title: "Model ",
          name: car.model,
        ),

        SubSec(
          title: "Year ",
          name: car.year.toString(),
        ),

        SubSec(
          title: "Milage ",
          name: car.mileage.toString(),
        ),

        SubSec(
          title: "Transmission ",
          name: car.transmission,
        ),

        SubSec(
          title: "Fuel ",
          name: car.fuel,
        ),

        SubSec(
          title: "Location ",
          name: car.location,
        ),

        const ThickDevider(),
        DetailsSec(
          th: th,
          details: car.features,
        ),
        const ThickDevider(),
        DescSec(
          th: th,
          description: car.description,
        ),
        Consumer2<CarCreateProvider, UserProvider>(
            builder: (context, cp, up, _) {
          return Padding(
            padding: const EdgeInsets.all(28.0),
            child: OutlineButton(
              icon: Icons.done,
              label: "Confirm",
              onPressed: () async {
                List<String> images = await cp.uploadImages(cp.carData!.images);

                print('New images: $images');
                cp.eitherFailureOrCarData(
                    value: CarModel(
                        id: const Uuid().v7(),
                        title:
                            "${car.make} ${car.model} ${car.year} ${car.location}",
                        make: car.make,
                        model: car.model,
                        year: car.year,
                        color: car.color,
                        price: car.price,
                        mileage: car.mileage,
                        description: car.description,
                        features: car.features,
                        images: car.images,
                        location: car.location,
                        transmission: car.transmission,
                        fuel: car.fuel,
                        sellerId: up.firebaseUser!.uid,
                        createdAt: car.createdAt,
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
                itemCount: cp.carData!.images.length,
                itemBuilder: (BuildContext context, int index) {
                  return Container(
                    margin: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                        color: Theme.of(context).splashColor,
                        image: DecorationImage(
                            image: FileImage(File(cp.carData!.images[index])))),
                    height: 120,
                    width: 120,
                    child: IconButton(
                        onPressed: () {
                          cp.deleteImage(cp.carData!.images[index]);
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

class LocationForm extends StatelessWidget {
  const LocationForm({
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
            onChanged: (value) =>
                context.read<CarCreateProvider>().updateLocation(value),
          ),
          CTextField(
            keyboardType: const TextInputType.numberWithOptions(),
            labelText: 'Price',
            onChanged: (value) => context.read<CarCreateProvider>().updatePrice(
                  double.parse(value),
                ),
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
    final carData = cp.carData!;
    if (carData.make.isEmpty) {
      _showErrorDialog(context, 'Please select a car make.');
      return;
    }
    if (carData.model.isEmpty) {
      _showErrorDialog(context, 'Please select a car model.');
      return;
    }
    if (carData.mileage <= 0) {
      _showErrorDialog(context, 'Please enter a valid mileage.');
      return;
    }
    if (carData.description.isEmpty) {
      _showErrorDialog(context, 'Please provide a description.');
      return;
    }
    if (carData.transmission.isEmpty) {
      _showErrorDialog(context, 'Please select a transmission type.');
      return;
    }
    if (carData.fuel.isEmpty) {
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
                    onSelected: cp.updateMake,
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
            onChanged: (value) => cp.updateMileage(int.tryParse(value) ?? 0),
          ),
          _buildTextField(
            label: 'Description',
            hint: 'A detailed description',
            keyboardType: TextInputType.multiline,
            onChanged: cp.updateDescription,
          ),
          _buildDropdown(
            label: 'Transmission',
            items: const ['Manual', 'Automatic', 'Hybrid'],
            onChanged: cp.updateTransmission,
          ),
          _buildDropdown(
            label: 'Fuel',
            items: const ['Diesel', 'Petrol', 'Electric', 'Hybrid', 'CNG'],
            onChanged: cp.updateFuel,
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
    List<String> models = cp.carData!.make.isNotEmpty
        ? jsonData
            .firstWhere(
              (brandData) => brandData['brand'] == cp.carData!.make,
              orElse: () => {'models': []},
            )['models']
            .cast<String>()
        : [];

    return _buildAutocomplete(
      label: 'Model',
      hint: 'Enter car model',
      options: models,
      onSelected: cp.updateModel,
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
          cp.updateYear(selectedYear);
        }
      },
      child: AbsorbPointer(
        child: _buildTextField(
          label: 'Year',
          hint: '2016*',
          controller: TextEditingController(
            text: cp.carData!.year.toString(),
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
                children: List<Widget>.generate(cp.carData!.features.length,
                    (int index) {
                  return Chip(
                    onDeleted: () {
                      cp.deleteFet(cp.carData!.features[index]);
                    },
                    label: Text(context
                        .watch<CarCreateProvider>()
                        .carData!
                        .features[index]),
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
                  onPressed: () {
                    cp.addFeature(fc.text);
                    fc.clear();
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
