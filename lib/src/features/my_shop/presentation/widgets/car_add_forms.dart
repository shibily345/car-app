import 'dart:convert';
import 'dart:io';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/src/features/cars/data/models/car_model.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';
import 'package:google_places_flutter/google_places_flutter.dart';
import 'package:google_places_flutter/model/prediction.dart';

// Helper function to create updated car model
CarModel _updateCarModel(
  CarModel? currentCar, {
  String? id,
  String? title,
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
  String? sellerId,
  DateTime? createdAt,
  DateTime? updatedAt,
  String? type,
  String? seats,
  bool? isVerified,
  bool? isForSale,
  bool? isForRent,
}) {
  return CarModel(
    id: id ?? currentCar?.id ?? '',
    title: title ?? currentCar?.title ?? '',
    make: make ?? currentCar?.make ?? '',
    model: model ?? currentCar?.model ?? '',
    year: year ?? currentCar?.year ?? DateTime.now().year,
    color: color ?? currentCar?.color ?? '',
    price: price ?? currentCar?.price ?? 0.0,
    mileage: mileage ?? currentCar?.mileage ?? 0,
    description: description ?? currentCar?.description ?? '',
    features: features ?? currentCar?.features ?? [],
    images: images ?? currentCar?.images ?? [],
    location: location ?? currentCar?.location ?? '',
    transmission: transmission ?? currentCar?.transmission ?? '',
    fuel: fuel ?? currentCar?.fuel ?? '',
    sellerId: sellerId ?? currentCar?.sellerId ?? '',
    createdAt: createdAt ?? currentCar?.createdAt ?? DateTime.now(),
    updatedAt: updatedAt ?? currentCar?.updatedAt ?? DateTime.now(),
    type: type ?? currentCar?.type ?? '',
    seats: seats ?? currentCar?.seats ?? '',
    isVerified: isVerified ?? currentCar?.isVerified ?? false,
    isForSale: isForSale ?? currentCar?.isForSale ?? false,
    isForRent: isForRent ?? currentCar?.isForRent ?? false,
  );
}

class CarDetailsForm extends StatefulWidget {
  final VoidCallback onNext;
  final CarCreateProvider carProvider;

  const CarDetailsForm({
    super.key,
    required this.onNext,
    required this.carProvider,
  });

  @override
  State<CarDetailsForm> createState() => _CarDetailsFormState();
}

class _CarDetailsFormState extends State<CarDetailsForm> {
  final _formKey = GlobalKey<FormState>();
  final _makeController = TextEditingController();
  final _modelController = TextEditingController();
  final _mileageController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _colorController = TextEditingController();
  String? _selectedTransmission;
  String? _selectedFuel;
  int? _selectedYear;
  String? _selectedType;
  int _seatCount = 4;

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final carData = widget.carProvider.carData;
    if (carData != null) {
      _makeController.text = carData.make ?? '';
      _modelController.text = carData.model ?? '';
      _mileageController.text = (carData.mileage ?? 0).toString();
      _descriptionController.text = carData.description ?? '';
      _colorController.text = carData.color ?? '';
      _selectedTransmission = carData.transmission;
      _selectedFuel = carData.fuel;
      _selectedYear = carData.year;
      _selectedType = carData.type;
      _seatCount = int.tryParse(carData.seats ?? '4') ?? 4;
    }
  }

  void _updateCarData() {
    final updatedCar = _updateCarModel(
      widget.carProvider.carData,
      make: _makeController.text,
      model: _modelController.text,
      mileage: int.tryParse(_mileageController.text) ?? 0,
      description: _descriptionController.text,
      color: _colorController.text,
      transmission: _selectedTransmission,
      fuel: _selectedFuel,
      year: _selectedYear,
      type: _selectedType,
      seats: _seatCount.toString(),
      isVerified: false,
      isForSale: false,
      isForRent: false,
    );
    widget.carProvider.updateCarData(updatedCar);
  }

  bool _validateForm() {
    if (!_formKey.currentState!.validate()) return false;
    if (_selectedTransmission == null) {
      _showError('Please select a transmission type');
      return false;
    }
    if (_selectedFuel == null) {
      _showError('Please select a fuel type');
      return false;
    }
    if (_selectedYear == null) {
      _showError('Please select a year');
      return false;
    }
    return true;
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
      ),
    );
  }

  @override
  void dispose() {
    _makeController.dispose();
    _modelController.dispose();
    _mileageController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  Icon(
                    Icons.car_rental,
                    color: theme.primaryColor,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Car Details',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: theme.primaryColor,
                          ),
                        ),
                        Text(
                          'Tell us about your vehicle',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Make and Model Section
            FutureBuilder<String>(
              future: DefaultAssetBundle.of(context)
                  .loadString('assets/data/vehicles.json'),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (snapshot.hasError || !snapshot.hasData) {
                  return const Card(
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Text('Error loading vehicle data'),
                    ),
                  );
                }

                final List<dynamic> jsonData =
                    json.decode(snapshot.data!)['brands'];
                final List<String> brands = jsonData
                    .map((brandData) => brandData['brand'] as String)
                    .toList();

                return Column(
                  children: [
                    _buildMakeDropdown(brands),
                    const SizedBox(height: 16),
                    _buildModelAutocomplete(jsonData),
                  ],
                );
              },
            ),

            const SizedBox(height: 16),

            // Year Selector
            _buildYearSelector(),

            const SizedBox(height: 16),

            // Car Type Dropdown
            _buildDropdown(
              label: 'Type',
              value: _selectedType,
              items: const [
                'SUV',
                'Hatchback',
                'Sedan',
                'Sport',
                'Coupe',
                'Convertible',
                'Wagon',
                'Van',
                'Pickup'
              ],
              onChanged: (value) {
                setState(() {
                  _selectedType = value;
                });
                _updateCarData();
              },
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please select car type';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Seat Selector
            Row(
              children: [
                const Text('Seats:', style: TextStyle(fontSize: 16)),
                const SizedBox(width: 16),
                IconButton(
                  icon: const Icon(Icons.remove),
                  onPressed: _seatCount > 1
                      ? () {
                          setState(() {
                            _seatCount--;
                          });
                          _updateCarData();
                        }
                      : null,
                ),
                Text('$_seatCount', style: const TextStyle(fontSize: 16)),
                IconButton(
                  icon: const Icon(Icons.add),
                  onPressed: _seatCount < 10
                      ? () {
                          setState(() {
                            _seatCount++;
                          });
                          _updateCarData();
                        }
                      : null,
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Color Field
            CTextField(
              controller: _colorController,
              labelText: 'Color',
              hintText: 'e.g., Red, Blue, Black',
              onChanged: (value) => _updateCarData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter car color';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Mileage
            CTextField(
              controller: _mileageController,
              labelText: 'Mileage (KM)',
              hintText: 'e.g., 50000',
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateCarData(),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter mileage';
                }
                final mileage = int.tryParse(value);
                if (mileage == null || mileage <= 0) {
                  return 'Please enter a valid mileage';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Description
            CTextField(
              controller: _descriptionController,
              labelText: 'Description',
              hintText: 'Describe your car in detail...',
              keyboardType: TextInputType.multiline,
              onChanged: (value) => _updateCarData(),
            ),

            const SizedBox(height: 16),

            // Transmission
            _buildDropdown(
              label: 'Transmission',
              value: _selectedTransmission,
              items: const ['Manual', 'Automatic', 'Hybrid'],
              onChanged: (value) {
                setState(() {
                  _selectedTransmission = value;
                });
                _updateCarData();
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select transmission type';
                }
                return null;
              },
            ),

            const SizedBox(height: 16),

            // Fuel Type
            _buildDropdown(
              label: 'Fuel Type',
              value: _selectedFuel,
              items: const ['Diesel', 'Petrol', 'Electric', 'Hybrid', 'CNG'],
              onChanged: (value) {
                setState(() {
                  _selectedFuel = value;
                });
                _updateCarData();
              },
              validator: (value) {
                if (value == null) {
                  return 'Please select fuel type';
                }
                return null;
              },
            ),

            const SizedBox(height: 32),

            // Next Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  if (_validateForm()) {
                    widget.onNext();
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: theme.primaryColor,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
                child: const Text(
                  'Next: Add Features',
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAutocompleteField({
    required String label,
    required String hint,
    required TextEditingController controller,
    required List<String> options,
    required Function(String) onChanged,
    String? Function(String?)? validator,
  }) {
    return Autocomplete<String>(
      optionsBuilder: (TextEditingValue textEditingValue) {
        // Show all options when field is empty or when user starts typing
        if (textEditingValue.text.isEmpty) {
          return options;
        }
        return options.where((option) =>
            option.toLowerCase().contains(textEditingValue.text.toLowerCase()));
      },
      onSelected: (String selection) {
        // Update the controller with the selected value
        controller.text = selection;
        onChanged(selection);
      },
      fieldViewBuilder:
          (context, textEditingController, focusNode, onFieldSubmitted) {
        return TextFormField(
          controller: textEditingController,
          focusNode: focusNode,
          decoration: InputDecoration(
            labelText: label,
            hintText: hint,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: const Icon(Icons.arrow_drop_down),
          ),
          validator: validator,
          onChanged: (value) {
            // Update the car data as user types
            if (options.contains(value)) {
              onChanged(value);
            }
          },
        );
      },
      optionsViewBuilder: (context, onSelected, options) {
        return Material(
          elevation: 4,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            constraints: const BoxConstraints(maxHeight: 200),
            child: ListView.builder(
              padding: EdgeInsets.zero,
              itemCount: options.length,
              itemBuilder: (context, index) {
                final option = options.elementAt(index);
                return ListTile(
                  title: Text(option),
                  onTap: () {
                    onSelected(option);
                  },
                  hoverColor: Colors.grey.shade100,
                  dense: true,
                );
              },
            ),
          ),
        );
      },
    );
  }

  Widget _buildMakeDropdown(List<String> brands) {
    return _buildAutocompleteField(
      label: 'Make',
      hint: 'Select car brand',
      controller: _makeController,
      options: brands,
      onChanged: (value) {
        _makeController.text = value;
        _modelController.clear();
        _updateCarData();
        setState(() {}); // Trigger rebuild for model field
      },
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a car make';
        }
        return null;
      },
    );
  }

  Widget _buildModelAutocomplete(List<dynamic> jsonData) {
    final currentMake = _makeController.text;
    List<String> models = currentMake.isNotEmpty
        ? jsonData
            .firstWhere(
              (brandData) => brandData['brand'] == currentMake,
              orElse: () => {'models': []},
            )['models']
            .cast<String>()
        : [];

    // If no make is selected, show a disabled field
    if (currentMake.isEmpty) {
      return TextFormField(
        controller: _modelController,
        enabled: false,
        decoration: InputDecoration(
          labelText: 'Model',
          hintText: 'Select make first',
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          filled: true,
          fillColor: Colors.grey.shade100,
          suffixIcon: const Icon(Icons.lock, color: Colors.grey),
        ),
        validator: (value) {
          return 'Please select a make first';
        },
      );
    }

    return _buildAutocompleteField(
      label: 'Model',
      hint: 'Select car model',
      controller: _modelController,
      options: models,
      onChanged: (value) => _updateCarData(),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please select a car model';
        }
        return null;
      },
    );
  }

  Widget _buildYearSelector() {
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
          setState(() {
            _selectedYear = selectedYear;
          });
          _updateCarData();
        }
      },
      child: AbsorbPointer(
        child: TextFormField(
          controller: TextEditingController(
            text: _selectedYear?.toString() ?? 'Select Year',
          ),
          decoration: InputDecoration(
            labelText: 'Year',
            hintText: 'Select year',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.grey.shade50,
            suffixIcon: const Icon(Icons.calendar_today),
          ),
          validator: (value) {
            if (_selectedYear == null) {
              return 'Please select a year';
            }
            return null;
          },
        ),
      ),
    );
  }

  Widget _buildDropdown({
    required String label,
    required String? value,
    required List<String> items,
    required Function(String?) onChanged,
    String? Function(String?)? validator,
  }) {
    return DropdownButtonFormField<String>(
      value: value,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        filled: true,
        fillColor: Colors.grey.shade50,
      ),
      items: items
          .map((item) => DropdownMenuItem(value: item, child: Text(item)))
          .toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }
}

class FeaturesForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final CarCreateProvider carProvider;

  const FeaturesForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.carProvider,
  });

  @override
  State<FeaturesForm> createState() => _FeaturesFormState();
}

class _FeaturesFormState extends State<FeaturesForm> {
  final TextEditingController _featureController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CarCreateProvider>(
      builder: (context, carProvider, _) {
        final features = carProvider.carData?.features ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.orange.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.star,
                      color: Colors.orange,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Features',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.orange,
                            ),
                          ),
                          Text(
                            'Add car features and amenities',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Existing Features
              if (features.isNotEmpty) ...[
                Text(
                  'Current Features',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: features.asMap().entries.map((entry) {
                    final index = entry.key;
                    final feature = entry.value;
                    return Chip(
                      label: Text(feature),
                      deleteIcon: const Icon(Icons.close, size: 18),
                      onDeleted: () {
                        final updatedFeatures = List<String>.from(features);
                        updatedFeatures.removeAt(index);
                        final updatedCar = _updateCarModel(
                          carProvider.carData,
                          features: updatedFeatures,
                        );
                        carProvider.updateCarData(updatedCar);
                      },
                      backgroundColor:
                          theme.primaryColor.withValues(alpha: 0.1),
                      deleteIconColor: Colors.red,
                    );
                  }).toList(),
                ),
                const SizedBox(height: 24),
              ],

              // Add New Feature
              Text(
                'Add New Feature',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              Row(
                children: [
                  Expanded(
                    child: CTextField(
                      controller: _featureController,
                      labelText: 'Feature Name',
                      hintText: 'e.g., Panoramic Roof, Leather Seats',
                    ),
                  ),
                  const SizedBox(width: 12),
                  FloatingActionButton(
                    heroTag: "addFeatureFAB",
                    onPressed: () {
                      if (_featureController.text.isNotEmpty) {
                        final updatedFeatures = List<String>.from(features);
                        updatedFeatures.add(_featureController.text);
                        final updatedCar = _updateCarModel(
                          carProvider.carData,
                          features: updatedFeatures,
                        );
                        carProvider.updateCarData(updatedCar);
                        _featureController.clear();
                      }
                    },
                    backgroundColor: theme.primaryColor,
                    foregroundColor: Colors.white,
                    elevation: 0,
                    child: const Icon(Icons.add),
                  ),
                ],
              ),

              const SizedBox(height: 32),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: widget.onPrevious,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: widget.onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next: Images'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class ImagesForm extends StatelessWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final CarCreateProvider carProvider;

  const ImagesForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.carProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer<CarCreateProvider>(
      builder: (context, carProvider, _) {
        final images = carProvider.carData?.images ?? [];

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.photo_library,
                      color: Colors.green,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Images',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          Text(
                            'Add photos of your car',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Upload Button
              GestureDetector(
                onTap: () => carProvider.pickImage(),
                child: Container(
                  width: double.infinity,
                  height: 120,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                      color: Colors.grey.shade300,
                      style: BorderStyle.solid,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.cloud_upload,
                        size: 48,
                        color: Colors.grey.shade600,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'Tap to upload images',
                        style: theme.textTheme.bodyMedium?.copyWith(
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 24),

              // Images Grid
              if (images.isNotEmpty) ...[
                Text(
                  'Uploaded Images (${images.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.builder(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 12,
                    mainAxisSpacing: 12,
                    childAspectRatio: 1,
                  ),
                  itemCount: images.length,
                  itemBuilder: (context, index) {
                    return Stack(
                      children: [
                        Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            image: DecorationImage(
                              image: FileImage(File(images[index])),
                              fit: BoxFit.cover,
                            ),
                          ),
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: GestureDetector(
                            onTap: () {
                              final updatedImages = List<String>.from(images);
                              updatedImages.removeAt(index);
                              final updatedCar = _updateCarModel(
                                carProvider.carData,
                                images: updatedImages,
                              );
                              carProvider.updateCarData(updatedCar);
                            },
                            child: Container(
                              padding: const EdgeInsets.all(4),
                              decoration: const BoxDecoration(
                                color: Colors.red,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 16,
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ],

              const SizedBox(height: 32),

              // Navigation Buttons
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: onPrevious,
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Previous'),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: onNext,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const Text('Next: Location & Price'),
                    ),
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }
}

class LocationPriceForm extends StatefulWidget {
  final VoidCallback onNext;
  final VoidCallback onPrevious;
  final CarCreateProvider carProvider;

  const LocationPriceForm({
    super.key,
    required this.onNext,
    required this.onPrevious,
    required this.carProvider,
  });

  @override
  State<LocationPriceForm> createState() => _LocationPriceFormState();
}

class _LocationPriceFormState extends State<LocationPriceForm> {
  final _locationController = TextEditingController();
  final _priceController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _locationFocusNode = FocusNode();

  // Google Places API Key
  static const String googleApiKey = 'AIzaSyBJPJF2kvkLCgrdMjjw8JvYnho47PR7HWM';

  @override
  void initState() {
    super.initState();
    _loadExistingData();
  }

  void _loadExistingData() {
    final carData = widget.carProvider.carData;
    if (carData != null) {
      _locationController.text = carData.location ?? '';
      _priceController.text = (carData.price ?? 0.0).toString();
    }
  }

  void _updateCarData() {
    final updatedCar = _updateCarModel(
      widget.carProvider.carData,
      location: _locationController.text,
      price: double.tryParse(_priceController.text) ?? 0.0,
    );
    widget.carProvider.updateCarData(updatedCar);
  }

  bool _validateForm() {
    return _formKey.currentState!.validate();
  }

  @override
  void dispose() {
    _locationFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.blue.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.location_on,
                    color: Colors.blue,
                    size: 32,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Location & Price',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                            color: Colors.blue,
                          ),
                        ),
                        Text(
                          'Set your location (Dubai/India) and pricing',
                          style: theme.textTheme.bodyMedium?.copyWith(
                            color: Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Location with Google Places Autocomplete
            GooglePlaceAutoCompleteTextField(
              textEditingController: _locationController,
              googleAPIKey: "AIzaSyC_NpLbfIEhkIUACoD0MqqZ7hrNWe3Nwl0",
              inputDecoration: InputDecoration(
                labelText: 'Location',
                hintText: 'e.g., Dubai, UAE or Mumbai, India',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                filled: true,
                fillColor: Colors.grey.shade50,
                prefixIcon: const Icon(Icons.location_on),
              ),
              debounceTime: 800,
              countries: const ["ae", "in"], // UAE and India
              isLatLngRequired: false,
              itemClick: (Prediction prediction) {
                _locationController.text = prediction.description ?? '';
                _locationController.selection = TextSelection.fromPosition(
                  TextPosition(offset: _locationController.text.length),
                );
                _updateCarData();
              },
              itemBuilder: (context, index, Prediction prediction) {
                return Container(
                  padding: const EdgeInsets.all(12),
                  child: Row(
                    children: [
                      const Icon(Icons.location_on, size: 20),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          prediction.description ?? '',
                          style: const TextStyle(fontSize: 14),
                        ),
                      ),
                    ],
                  ),
                );
              },
              seperatedBuilder: const Divider(height: 1),
              isCrossBtnShown: true,
              containerHorizontalPadding: 10,
            ),

            const SizedBox(height: 16),

            // Price
            CTextField(
              controller: _priceController,
              labelText: 'Price (AED)',
              hintText: 'e.g., 50000',
              keyboardType: TextInputType.number,
              onChanged: (value) => _updateCarData(),
            ),

            const SizedBox(height: 32),

            // Navigation Buttons
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: widget.onPrevious,
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Previous'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      if (_validateForm()) {
                        widget.onNext();
                      }
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: theme.primaryColor,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: const Text('Review & Submit'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ReviewForm extends StatelessWidget {
  final VoidCallback onPrevious;
  final CarCreateProvider carProvider;

  const ReviewForm({
    super.key,
    required this.onPrevious,
    required this.carProvider,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Consumer2<CarCreateProvider, UserProvider>(
      builder: (context, carProvider, userProvider, _) {
        final carData = carProvider.carData;
        if (carData == null) {
          return const Center(child: Text('No car data available'));
        }

        return SingleChildScrollView(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.purple.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    const Icon(
                      Icons.check_circle,
                      color: Colors.purple,
                      size: 32,
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Review & Submit',
                            style: theme.textTheme.headlineSmall?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Colors.purple,
                            ),
                          ),
                          Text(
                            'Review your car details before submitting',
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),

              // Car Images
              if (carData.images?.isNotEmpty == true) ...[
                Text(
                  'Images (${carData.images!.length})',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                SizedBox(
                  height: 120,
                  child: ListView.builder(
                    scrollDirection: Axis.horizontal,
                    itemCount: carData.images!.length,
                    itemBuilder: (context, index) {
                      return Container(
                        width: 120,
                        margin: const EdgeInsets.only(right: 12),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12),
                          image: DecorationImage(
                            image: FileImage(File(carData.images![index])),
                            fit: BoxFit.cover,
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(height: 24),
              ],

              // Car Details
              _buildDetailCard(
                title: 'Car Details',
                icon: Icons.car_rental,
                color: theme.primaryColor,
                children: [
                  _buildDetailRow('Make', carData.make ?? ''),
                  _buildDetailRow('Model', carData.model ?? ''),
                  _buildDetailRow('Year', (carData.year ?? 0).toString()),
                  _buildDetailRow('Color', carData.color ?? ''),
                  _buildDetailRow('Type', carData.type ?? ''),
                  _buildDetailRow('Seats', carData.seats ?? ''),
                  _buildDetailRow('Mileage', '${carData.mileage ?? 0} KM'),
                  _buildDetailRow('Transmission', carData.transmission ?? ''),
                  _buildDetailRow('Fuel Type', carData.fuel ?? ''),
                ],
              ),

              const SizedBox(height: 16),

              // Features
              if (carData.features?.isNotEmpty == true) ...[
                _buildDetailCard(
                  title: 'Features',
                  icon: Icons.star,
                  color: Colors.orange,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: (carData.features ?? []).map((feature) {
                        return Chip(
                          label: Text(feature),
                          backgroundColor: Colors.orange.withValues(alpha: 0.1),
                        );
                      }).toList(),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Location & Price
              _buildDetailCard(
                title: 'Location & Price',
                icon: Icons.location_on,
                color: Colors.blue,
                children: [
                  _buildDetailRow('Location', carData.location ?? ''),
                  _buildDetailRow('Price', 'AED ${carData.price ?? 0}'),
                ],
              ),

              const SizedBox(height: 16),

              // Description
              if (carData.description?.isNotEmpty == true) ...[
                _buildDetailCard(
                  title: 'Description',
                  icon: Icons.description,
                  color: Colors.green,
                  children: [
                    Text(
                      carData.description ?? '',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
                const SizedBox(height: 16),
              ],

              // Submit Button
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () async {
                    try {
                      // Upload images first
                      List<String> uploadedImages =
                          await carProvider.uploadImages(
                        carData.images ?? [],
                      );

                      // Create final car model
                      final finalCar = CarModel(
                        id: const Uuid().v7(),
                        title:
                            "${carData.make ?? ''} ${carData.model ?? ''} ${carData.year ?? DateTime.now().year} ${carData.location ?? ''}",
                        make: carData.make ?? '',
                        model: carData.model ?? '',
                        year: carData.year ?? DateTime.now().year,
                        color: carData.color ?? '',
                        price: carData.price ?? 0.0,
                        mileage: carData.mileage ?? 0,
                        description: carData.description ?? '',
                        features: carData.features ?? [],
                        images: uploadedImages,
                        location: carData.location ?? '',
                        transmission: carData.transmission ?? '',
                        fuel: carData.fuel ?? '',
                        sellerId: userProvider.cSeller?.id ?? '',
                        createdAt: DateTime.now(),
                        updatedAt: DateTime.now(),
                        type: carData.type ?? '',
                        seats: carData.seats ?? '4',
                        isVerified: carData.isVerified ?? false,
                        isForSale: carData.isForSale ?? false,
                        isForRent: carData.isForRent ?? false,
                      );

                      // Submit car data

                      // Navigate back to home
                      if (context.mounted) {
                        carProvider.eitherFailureOrCarData(
                            value: finalCar, context: context);
                        // Navigator.pop(context);
                        final carsProvider =
                            Provider.of<CarsProvider>(context, listen: false);

                        // Refresh cars, rentals, and sales data
                        carsProvider.eitherFailureOrCars();
                        // Navigator.pushReplacementNamed(context, "/");
                      }
                    } catch (e) {
                      if (context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Error submitting car: $e'),
                            backgroundColor: Colors.red,
                          ),
                        );
                      }
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text(
                    'Submit Car Listing',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                ),
              ),

              const SizedBox(height: 16),

              // Back Button
              SizedBox(
                width: double.infinity,
                child: OutlinedButton(
                  onPressed: onPrevious,
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: const Text('Back to Edit'),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildDetailCard({
    required String title,
    required IconData icon,
    required Color color,
    required List<Widget> children,
  }) {
    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Icon(icon, color: color, size: 24),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ...children,
          ],
        ),
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 100,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w500,
                color: Colors.grey,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
        ],
      ),
    );
  }
}
