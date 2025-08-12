import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/features/sale/business/entities/sale_entity.dart';
import 'package:car_app_beta/src/features/sale/data/models/sale_model.dart';
import 'package:car_app_beta/src/features/sale/presentation/providers/sale_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/custom_button.dart';
import 'package:car_app_beta/src/widgets/inputs/styled_inputs.dart';
import 'package:car_app_beta/src/widgets/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class AddSalePage extends StatefulWidget {
  final String? carId;
  const AddSalePage({super.key, this.carId});

  @override
  State<AddSalePage> createState() => _AddSalePageState();
}

class _AddSalePageState extends State<AddSalePage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _registrationController = TextEditingController();
  final _inspectionReportController = TextEditingController();

  // Form values
  String? _selectedCarId;
  String? _preselectedCarId;
  bool _isAvailable = true;
  String _status = 'active';
  DateTime? _lastMaintenanceDate;
  DateTime? _nextMaintenanceDate;

  // Location variables
  LatLng? _selectedLocation;
  String? _locationAddress;

  bool _isSubmitting = false;

  @override
  void initState() {
    super.initState();
    if (widget.carId != null) {
      _selectedCarId = widget.carId!;
    }
    // Set default price
    _priceController.text = '25000';

    // Initialize location from seller data (will be set in didChangeDependencies)
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_preselectedCarId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _preselectedCarId = args;
        _selectedCarId = args;
        // Populate car details when preselected
        _populateCarDetails(args);
      }
    }

    // Initialize location from seller data if not already set
    if (_selectedLocation == null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      if (userProvider.cSeller != null) {
        // Set default coordinates from seller location
        // You can customize these default coordinates based on your needs
        _selectedLocation = const LatLng(25.2048, 55.2708); // Default to Dubai
        _locationAddress = userProvider.cSeller!.location;
      }
    }
  }

  void _populateCarDetails(String carId) {
    final carsProvider = Provider.of<CarsProvider>(context, listen: false);
    if (carsProvider.cars != null) {
      try {
        final selectedCar =
            carsProvider.cars!.firstWhere((car) => car.id == carId);
        _descriptionController.text =
            '${selectedCar.make} ${selectedCar.model} ${selectedCar.year} - ${selectedCar.mileage}km, ${selectedCar.fuel ?? 'N/A'}';
        _priceController.text = selectedCar.price?.toString() ?? '25000';
      } catch (e) {
        debugPrint('Car not found: $carId');
      }
    }
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    _registrationController.dispose();
    _inspectionReportController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Sale Listing'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),
      body: Consumer3<UserProvider, CarsProvider, SaleProvider>(
        builder: (context, userProvider, carsProvider, saleProvider, _) {
          if (userProvider.firebaseUser == null) {
            return const Center(
                child: Text('Please log in to add a sale listing.'));
          }
          if (carsProvider.cars == null) {
            return const Center(child: CircularProgressIndicator());
          }
          final String id = userProvider.cSeller!.id;
          // final String uid = userProvider.firebaseUser!.uid;
          final List<CarEntity> userCars =
              carsProvider.cars!.where((car) => car.sellerId == id).toList();

          if (userCars.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.sell, size: 60, color: Colors.green),
                  const SizedBox(height: 16),
                  const Text(
                    'No cars found!\nAdd a car to your garage before listing for sale.',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                  const SizedBox(height: 24),
                  ElevatedButton.icon(
                    onPressed: () => Navigator.pushNamed(context, '/addNew'),
                    icon: const Icon(Icons.add),
                    label: const Text('Add Car'),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ],
              ),
            );
          }

          return Form(
            key: _formKey,
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildSectionCard([
                    _buildSectionTitle('Select Car'),
                    _buildCarDropdown(userCars),
                  ]),
                  const SpaceY(16),
                  _buildSectionCard([
                    _buildSectionTitle('Sale Details'),
                    _buildSaleDetailsSection(),
                  ]),
                  const SpaceY(16),
                  _buildSectionCard([
                    _buildSectionTitle('Sale Location Coordinates'),
                    _buildLocationSection(),
                  ]),
                  const SpaceY(16),
                  _buildSectionCard([
                    _buildSectionTitle('Documents'),
                    _buildDocumentsSection(),
                  ]),
                  const SpaceY(16),
                  _buildSectionCard([
                    _buildSectionTitle('Maintenance History'),
                    _buildMaintenanceSection(),
                  ]),
                  const SpaceY(24),
                  _isSubmitting || saleProvider.isLoading
                      ? const Center(child: CircularProgressIndicator())
                      : _buildSubmitButton(saleProvider, id),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: TextDef(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
          color: Colors.green,
        ),
      ),
    );
  }

  Widget _buildCarDropdown(List<CarEntity> cars) {
    final isPreselected = _preselectedCarId != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (isPreselected)
          Padding(
            padding: const EdgeInsets.only(bottom: 8.0),
            child: Chip(
              avatar:
                  const Icon(Icons.check_circle, color: Colors.green, size: 20),
              label: Text('Selected from My Garage',
                  style: TextStyle(
                      color: Colors.green.shade800,
                      fontWeight: FontWeight.bold)),
              backgroundColor: Colors.green.shade50,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8)),
            ),
          ),
        DropdownButtonFormField<String>(
          value: _selectedCarId,
          decoration: InputDecoration(
            labelText: 'Select Car',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(
                color: isPreselected ? Colors.green : Colors.green,
                width: 2,
              ),
            ),
            filled: isPreselected,
            fillColor: isPreselected ? Colors.green.shade50 : null,
            suffixIcon: isPreselected
                ? const Icon(Icons.check_circle, color: Colors.green)
                : null,
          ),
          items: cars.map((car) {
            return DropdownMenuItem(
              value: car.id,
              child: Text('${car.make} ${car.model} ${car.year}'),
            );
          }).toList(),
          onChanged: isPreselected
              ? null
              : (value) {
                  setState(() {
                    _selectedCarId = value;
                    // Populate description and price from selected car
                    if (value != null) {
                      final selectedCar =
                          cars.firstWhere((car) => car.id == value);
                      _descriptionController.text =
                          '${selectedCar.make} ${selectedCar.model} ${selectedCar.year} - ${selectedCar.mileage}km, ${selectedCar.fuel ?? 'N/A'}';
                      _priceController.text =
                          selectedCar.price?.toString() ?? '25000';
                    }
                  });
                },
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please select a car';
            }
            return null;
          },
        ),
      ],
    );
  }

  Widget _buildSaleDetailsSection() {
    return Column(
      children: [
        StyledTextField(
          controller: _priceController,
          label: 'Sale Price (\$)',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter sale price';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid price';
            }
            return null;
          },
        ),
        const SpaceY(10),
        StyledTextField(
          controller: _descriptionController,
          label: 'Description',
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter a description';
            }
            return null;
          },
        ),
        const SpaceY(10),
        SwitchListTile(
          title: const Text('Available for Sale'),
          value: _isAvailable,
          onChanged: (value) {
            setState(() {
              _isAvailable = value ?? true;
            });
          },
        ),
        const SpaceY(10),
        DropdownButtonFormField<String>(
          value: _status,
          decoration: const InputDecoration(
            labelText: 'Sale Status',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'active', child: Text('Active')),
            DropdownMenuItem(value: 'inactive', child: Text('Inactive')),
            DropdownMenuItem(value: 'sold', child: Text('Sold')),
          ],
          onChanged: (value) {
            setState(() {
              _status = value ?? 'active';
            });
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        GestureDetector(
          onTap: () => _showLocationPicker(),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: _selectedLocation != null
                  ? Colors.green.shade50
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedLocation != null
                    ? Colors.green.shade300
                    : Colors.grey.shade300,
                width: _selectedLocation != null ? 2 : 1,
              ),
            ),
            child: Row(
              children: [
                Icon(
                  _selectedLocation != null
                      ? Icons.location_on
                      : Icons.location_on_outlined,
                  color: _selectedLocation != null
                      ? Colors.green.shade600
                      : Colors.grey.shade600,
                  size: 20,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _selectedLocation != null
                            ? (_locationAddress ?? 'Converting coordinates...')
                            : 'Select Sale Location Coordinates',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                          color: _selectedLocation != null
                              ? Colors.black
                              : Colors.grey.shade600,
                        ),
                      ),
                      if (_selectedLocation != null)
                        Text(
                          'Lat: ${_selectedLocation!.latitude.toStringAsFixed(6)}, Lng: ${_selectedLocation!.longitude.toStringAsFixed(6)}',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                    ],
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey.shade400,
                  size: 16,
                ),
              ],
            ),
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.green.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.green.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Coordinates selected successfully',
                      style: TextStyle(
                        color: Colors.green.shade700,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  void _showLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          initialLocation: _selectedLocation,
          title: 'Select Sale Location Coordinates',
          onLocationSelected: (latLng, address) {
            debugPrint('=== LOCATION PICKER CALLBACK ===');
            debugPrint(
                'Location selected: ${latLng.latitude}, ${latLng.longitude}');
            debugPrint('Address from picker: "$address"');
            debugPrint('================================');

            setState(() {
              _selectedLocation = latLng;
              _locationAddress = address;
              debugPrint(
                  'Updated state - Location: $_selectedLocation, Address: $_locationAddress');
            });
          },
        ),
      ),
    );
  }

  Widget _buildDocumentsSection() {
    return Column(
      children: [
        StyledTextField(
          controller: _registrationController,
          label: 'Registration Document URL',
          hint: 'https://example.com/registration.pdf',
        ),
        const SpaceY(10),
        StyledTextField(
          controller: _inspectionReportController,
          label: 'Inspection Report URL',
          hint: 'https://example.com/inspection.pdf',
        ),
      ],
    );
  }

  Widget _buildMaintenanceSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Last Maintenance'),
                subtitle: Text(_lastMaintenanceDate == null
                    ? 'Optional (default: 30 days ago)'
                    : _lastMaintenanceDate!.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _lastMaintenanceDate ??
                        DateTime.now().subtract(const Duration(days: 30)),
                    firstDate: DateTime(2000),
                    lastDate: DateTime.now(),
                  );
                  if (date != null) {
                    setState(() {
                      _lastMaintenanceDate = date;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Next Maintenance'),
                subtitle: Text(_nextMaintenanceDate == null
                    ? 'Optional (default: 90 days from now)'
                    : _nextMaintenanceDate!.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _nextMaintenanceDate ??
                        DateTime.now().add(const Duration(days: 90)),
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _nextMaintenanceDate = date;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        if (_lastMaintenanceDate != null || _nextMaintenanceDate != null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                if (_lastMaintenanceDate != null)
                  Expanded(
                    child: Chip(
                      avatar: const Icon(Icons.history, color: Colors.blue),
                      label: Text(
                          'Last: ${_lastMaintenanceDate!.toString().split(' ')[0]}'),
                      backgroundColor: Colors.blue.shade50,
                    ),
                  ),
                if (_lastMaintenanceDate != null &&
                    _nextMaintenanceDate != null)
                  const SizedBox(width: 8),
                if (_nextMaintenanceDate != null)
                  Expanded(
                    child: Chip(
                      avatar: const Icon(Icons.schedule, color: Colors.orange),
                      label: Text(
                          'Next: ${_nextMaintenanceDate!.toString().split(' ')[0]}'),
                      backgroundColor: Colors.orange.shade50,
                    ),
                  ),
              ],
            ),
          ),
        if (_lastMaintenanceDate == null && _nextMaintenanceDate == null)
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Icon(Icons.info_outline,
                      color: Colors.grey.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Maintenance dates are optional. Default values will be used if not set.',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildSubmitButton(SaleProvider saleProvider, String uid) {
    final isLoading = saleProvider.isLoading || _isSubmitting;

    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: isLoading
            ? const SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : const Icon(Icons.check_circle, color: Colors.white),
        label: Text(
          isLoading ? 'Creating Sale Listing...' : 'Create Sale Listing',
          style: const TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey : Colors.green,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: isLoading
            ? null
            : () async {
                setState(() => _isSubmitting = true);
                await Future.delayed(const Duration(milliseconds: 300));
                _submitForm(saleProvider, uid);
                setState(() => _isSubmitting = false);
              },
      ),
    );
  }

  void _submitForm(SaleProvider saleProvider, String uid) {
    debugPrint('AddSalePage: Starting form submission');
    debugPrint('AddSalePage: User ID (uid): $uid');
    debugPrint('AddSalePage: Selected car ID: $_selectedCarId');
    debugPrint('AddSalePage: Price: ${_priceController.text}');
    debugPrint('AddSalePage: Description: ${_descriptionController.text}');
    debugPrint('AddSalePage: Last maintenance: $_lastMaintenanceDate');
    debugPrint('AddSalePage: Next maintenance: $_nextMaintenanceDate');

    // Get the selected car details for debugging
    if (_selectedCarId != null) {
      final carsProvider = Provider.of<CarsProvider>(context, listen: false);
      final selectedCar =
          carsProvider.cars?.firstWhere((car) => car.id == _selectedCarId);
      if (selectedCar != null) {
        debugPrint('AddSalePage: Selected car details:');
        debugPrint('AddSalePage: - Car ID: ${selectedCar.id}');
        debugPrint('AddSalePage: - Car Seller ID: ${selectedCar.sellerId}');
        debugPrint('AddSalePage: - Car Make: ${selectedCar.make}');
        debugPrint('AddSalePage: - Car Model: ${selectedCar.model}');
        debugPrint('AddSalePage: - Car Year: ${selectedCar.year}');
        debugPrint('AddSalePage: - Current User ID: $uid');
        debugPrint('AddSalePage: - IDs Match: ${selectedCar.sellerId == uid}');
      }
    }

    if (!_formKey.currentState!.validate()) {
      debugPrint('AddSalePage: Form validation failed');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedCarId == null) {
      debugPrint('AddSalePage: No car selected');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a car'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      debugPrint('AddSalePage: Invalid price: ${_priceController.text}');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Test minimal sale object first
    debugPrint('AddSalePage: Testing minimal sale object creation...');
    final testSale = SaleModel(
      sellerId: uid,
      carId: _selectedCarId!,
      price: price,
      isAvailable: _isAvailable,
      status: _status,
      description: _descriptionController.text.trim(),
      coordinates: {
        'latitude': _selectedLocation?.latitude ?? 25.2048,
        'longitude': _selectedLocation?.longitude ?? 55.2708,
      },
      documents: SaleDocumentsModel(
        registration: '',
        inspectionReport: '',
        lastMaintenanceDate: DateTime.now(),
        nextMaintenanceDate: DateTime.now(),
      ),
      statistics: const SaleStatisticsModel(
        totalViews: 0,
        totalInquiries: 0,
        averageRating: 0,
        totalReviews: 0,
      ),
    );

    debugPrint('AddSalePage: Test sale object created successfully');
    debugPrint('AddSalePage: Test sale sellerId: ${testSale.sellerId}');
    debugPrint('AddSalePage: Test sale carId: ${testSale.carId}');
    debugPrint('AddSalePage: Test sale price: ${testSale.price}');

    final testJson = testSale.toJson();
    debugPrint('AddSalePage: Test sale toJson: $testJson');

    final sale = SaleModel(
      sellerId: uid,
      carId: _selectedCarId!,
      price: price,
      isAvailable: _isAvailable,
      status: _status,
      description: _descriptionController.text.trim(),
      coordinates: {
        'latitude': _selectedLocation?.latitude ?? 25.2048,
        'longitude': _selectedLocation?.longitude ?? 55.2708,
      },
      documents: SaleDocumentsModel(
        registration: _registrationController.text.trim(),
        inspectionReport: _inspectionReportController.text.trim(),
        lastMaintenanceDate: _lastMaintenanceDate ??
            DateTime.now().subtract(const Duration(days: 30)),
        nextMaintenanceDate: _nextMaintenanceDate ??
            DateTime.now().add(const Duration(days: 90)),
      ),
      statistics: const SaleStatisticsModel(
        totalViews: 0,
        totalInquiries: 0,
        averageRating: 0,
        totalReviews: 0,
      ),
    );

    debugPrint('AddSalePage: Created sale model, calling provider');
    debugPrint('AddSalePage: Final Sale Model:');
    debugPrint('AddSalePage: - Seller ID: ${sale.sellerId}');
    debugPrint('AddSalePage: - Car ID: ${sale.carId}');
    debugPrint('AddSalePage: - Price: ${sale.price}');
    debugPrint('AddSalePage: - Status: ${sale.status}');
    debugPrint('AddSalePage: - Description: ${sale.description}');
    debugPrint('AddSalePage: - Is Available: ${sale.isAvailable}');
    debugPrint('AddSalePage: - Documents: ${sale.documents}');
    debugPrint('AddSalePage: - Statistics: ${sale.statistics}');
    debugPrint('AddSalePage: Sale object type: ${sale.runtimeType}');

    // Debug the toJson method specifically
    try {
      final saleJson = sale.toJson();
      debugPrint('AddSalePage: Sale toJson result: $saleJson');
      debugPrint('AddSalePage: Sale toJson keys: ${saleJson.keys.toList()}');
      debugPrint('AddSalePage: Sale toJson length: ${saleJson.length}');
    } catch (e) {
      debugPrint('AddSalePage: Error in toJson: $e');
    }

    debugPrint('AddSalePage: Sale model JSON: ${sale.toJson()}');

    saleProvider.createSale(sale).then((_) {
      debugPrint('AddSalePage: Provider call completed');
      debugPrint(
          'AddSalePage: Create sale state: ${saleProvider.createSaleState.runtimeType}');

      if (saleProvider.createSaleState is DataSuccess) {
        debugPrint('AddSalePage: Sale created successfully');

        // Refresh all providers
        final carsProvider = Provider.of<CarsProvider>(context, listen: false);
        final rentalProvider =
            Provider.of<RentalProvider>(context, listen: false);

        // Refresh cars, rentals, and sales data
        carsProvider.eitherFailureOrCars();
        rentalProvider.getAllRentals();
        saleProvider.getAllSales();

        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Sale listing created successfully!'),
            backgroundColor: Colors.green,
            duration: Duration(seconds: 2),
          ),
        );

        // Clear the form and navigate back to my-shop page
        saleProvider.clearStates();
        Navigator.pushNamedAndRemoveUntil(
          context,
          '/myShop',
          (route) => false,
        );
      } else if (saleProvider.errorMessage != null) {
        debugPrint(
            'AddSalePage: Sale creation failed with error: ${saleProvider.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to create sale: ${saleProvider.errorMessage}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 3),
          ),
        );
      } else {
        debugPrint('AddSalePage: Unexpected error occurred');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('An unexpected error occurred'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }).catchError((error) {
      debugPrint('AddSalePage: Caught error: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error: ${error.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    });
  }

  Widget _buildSectionCard(List<Widget> children) {
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      margin: EdgeInsets.zero,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: children,
        ),
      ),
    );
  }
}
