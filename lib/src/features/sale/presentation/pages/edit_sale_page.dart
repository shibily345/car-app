import 'package:car_app_beta/core/resources/data_state.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/features/sale/business/entities/sale_entity.dart';
import 'package:car_app_beta/src/features/sale/data/models/sale_model.dart';
import 'package:car_app_beta/src/features/sale/presentation/providers/sale_provider.dart';
import 'package:car_app_beta/src/widgets/inputs/styled_inputs.dart';
import 'package:car_app_beta/src/widgets/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:flutter/foundation.dart';

class EditSalePage extends StatefulWidget {
  final String carId;
  const EditSalePage({super.key, required this.carId});

  @override
  State<EditSalePage> createState() => _EditSalePageState();
}

class _EditSalePageState extends State<EditSalePage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _priceController = TextEditingController();
  final _descriptionController = TextEditingController();
  final _registrationController = TextEditingController();
  final _inspectionReportController = TextEditingController();

  // Form values
  String? _selectedCarId;
  bool _isAvailable = true;
  String _status = 'active';
  DateTime? _lastMaintenanceDate;
  DateTime? _nextMaintenanceDate;

  // Location variables
  LatLng? _selectedLocation;
  String? _locationAddress;

  bool _isSubmitting = false;
  bool _isLoadingSale = true;
  bool _hasFetchedSale = false;
  SaleEntity? _loadedSale;

  @override
  void initState() {
    super.initState();
    _selectedCarId = widget.carId;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch sale details only once
    if (!_hasFetchedSale && _selectedCarId != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final saleProvider = Provider.of<SaleProvider>(context, listen: false);
      if (userProvider.firebaseUser != null) {
        _hasFetchedSale = true;
        // Get seller sales first, then find the one that matches the carId
        saleProvider.getSellerSales(userProvider.cSeller!.id).then((_) {
          final sale = saleProvider.getSaleByCarId(_selectedCarId!);
          if (sale != null) {
            _fillFormFields(sale);
          } else {
            debugPrint('Sale not found for carId: $_selectedCarId');
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Sale not found for this car'),
                backgroundColor: Colors.red,
              ),
            );
          }
          setState(() {
            _isLoadingSale = false;
          });
        }).catchError((error) {
          debugPrint('Error fetching sale: $error');
          setState(() {
            _isLoadingSale = false;
          });
        });
      } else {
        setState(() {
          _isLoadingSale = false;
        });
      }
    }
  }

  void _fillFormFields(SaleEntity sale) {
    setState(() {
      _loadedSale = sale;
      _priceController.text = sale.price.toString();
      _descriptionController.text = sale.description;
      _registrationController.text = sale.documents.registration;
      _inspectionReportController.text = sale.documents.inspectionReport;
      _isAvailable = sale.isAvailable;
      _status = sale.status;
      _lastMaintenanceDate = sale.documents.lastMaintenanceDate;
      _nextMaintenanceDate = sale.documents.nextMaintenanceDate;

      // Set location data from sale coordinates
      if (sale.coordinates.isNotEmpty) {
        final lat = sale.coordinates['latitude'] as double?;
        final lng = sale.coordinates['longitude'] as double?;
        if (lat != null && lng != null) {
          _selectedLocation = LatLng(lat, lng);
          _locationAddress =
              'Lat: ${lat.toStringAsFixed(6)}, Lng: ${lng.toStringAsFixed(6)}';
        }
      }
    });
  }

  @override
  void dispose() {
    _priceController.dispose();
    _descriptionController.dispose();
    _registrationController.dispose();
    _inspectionReportController.dispose();
    super.dispose();
  }

  Future<void> _pickDate(BuildContext context, bool isLast) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: isLast
          ? (_lastMaintenanceDate ??
              DateTime.now().subtract(const Duration(days: 30)))
          : (_nextMaintenanceDate ??
              DateTime.now().add(const Duration(days: 90))),
      firstDate: DateTime(2000),
      lastDate: DateTime(2100),
    );
    if (picked != null) {
      setState(() {
        if (isLast) {
          _lastMaintenanceDate = picked;
        } else {
          _nextMaintenanceDate = picked;
        }
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Edit Sale Listing'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingSale
          ? const Center(child: CircularProgressIndicator())
          : _loadedSale == null
              ? const Center(
                  child: Text('Sale not found or error loading sale data'),
                )
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16.0),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        _buildSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Sale Details'),
                              const SpaceY(16),
                              StyledTextField(
                                controller: _priceController,
                                hint: 'Price',
                                prefixIcon: Icons.attach_money,
                                keyboardType: TextInputType.number,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a price';
                                  }
                                  if (double.tryParse(value) == null) {
                                    return 'Please enter a valid number';
                                  }
                                  return null;
                                },
                              ),
                              const SpaceY(16),
                              StyledTextField(
                                controller: _descriptionController,
                                hint: 'Description',
                                prefixIcon: Icons.description,
                                validator: (value) {
                                  if (value == null || value.isEmpty) {
                                    return 'Please enter a description';
                                  }
                                  return null;
                                },
                              ),
                              const SpaceY(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: SwitchListTile(
                                      title: const Text('Available'),
                                      value: _isAvailable,
                                      onChanged: (value) {
                                        setState(() {
                                          _isAvailable = value;
                                        });
                                      },
                                    ),
                                  ),
                                  Expanded(
                                    child: DropdownButtonFormField<String>(
                                      value: _status,
                                      decoration: const InputDecoration(
                                        labelText: 'Status',
                                        border: OutlineInputBorder(),
                                      ),
                                      items: const [
                                        DropdownMenuItem(
                                            value: 'active',
                                            child: Text('Active')),
                                        DropdownMenuItem(
                                            value: 'pending',
                                            child: Text('Pending')),
                                        DropdownMenuItem(
                                            value: 'sold', child: Text('Sold')),
                                      ],
                                      onChanged: (value) {
                                        setState(() {
                                          _status = value!;
                                        });
                                      },
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        const SpaceY(16),
                        _buildSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Sale Location Coordinates'),
                              const SpaceY(16),
                              _buildLocationSection(),
                            ],
                          ),
                        ),
                        const SpaceY(16),
                        _buildSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Documents'),
                              const SpaceY(16),
                              StyledTextField(
                                controller: _registrationController,
                                hint: 'Registration Number',
                                prefixIcon: Icons.document_scanner,
                              ),
                              const SpaceY(16),
                              StyledTextField(
                                controller: _inspectionReportController,
                                hint: 'Inspection Report',
                                prefixIcon: Icons.assessment,
                              ),
                            ],
                          ),
                        ),
                        const SpaceY(16),
                        _buildSectionCard(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              _buildSectionTitle('Maintenance History'),
                              const SpaceY(16),
                              Row(
                                children: [
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickDate(context, true),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.history,
                                                color: Colors.blue),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _lastMaintenanceDate != null
                                                    ? 'Last: ${_lastMaintenanceDate!.toString().split(' ')[0]}'
                                                    : 'Last Maintenance Date',
                                                style: TextStyle(
                                                  color: _lastMaintenanceDate !=
                                                          null
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Expanded(
                                    child: InkWell(
                                      onTap: () => _pickDate(context, false),
                                      child: Container(
                                        padding: const EdgeInsets.all(12),
                                        decoration: BoxDecoration(
                                          border:
                                              Border.all(color: Colors.grey),
                                          borderRadius:
                                              BorderRadius.circular(8),
                                        ),
                                        child: Row(
                                          children: [
                                            const Icon(Icons.schedule,
                                                color: Colors.orange),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                _nextMaintenanceDate != null
                                                    ? 'Next: ${_nextMaintenanceDate!.toString().split(' ')[0]}'
                                                    : 'Next Maintenance Date',
                                                style: TextStyle(
                                                  color: _nextMaintenanceDate !=
                                                          null
                                                      ? Colors.black
                                                      : Colors.grey,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              if (_lastMaintenanceDate != null ||
                                  _nextMaintenanceDate != null) ...[
                                const SpaceY(12),
                                Row(
                                  children: [
                                    if (_lastMaintenanceDate != null)
                                      Expanded(
                                        child: Chip(
                                          avatar: const Icon(Icons.history,
                                              color: Colors.blue),
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
                                          avatar: const Icon(Icons.schedule,
                                              color: Colors.orange),
                                          label: Text(
                                              'Next: ${_nextMaintenanceDate!.toString().split(' ')[0]}'),
                                          backgroundColor:
                                              Colors.orange.shade50,
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SpaceY(24),
                        Consumer2<SaleProvider, UserProvider>(
                          builder:
                              (context, saleProvider, userProvider, child) {
                            return _isSubmitting || saleProvider.isLoading
                                ? const Center(
                                    child: CircularProgressIndicator())
                                : Column(
                                    children: [
                                      _buildSubmitButton(saleProvider,
                                          userProvider.firebaseUser!.uid),
                                      const SpaceY(12),
                                      _buildDeleteButton(saleProvider),
                                    ],
                                  );
                          },
                        ),
                      ],
                    ),
                  ),
                ),
    );
  }

  Widget _buildSectionCard({required Widget child}) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildSectionTitle(String title) {
    return Text(
      title,
      style: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Colors.blue,
      ),
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
                  ? Colors.blue.shade50
                  : Colors.grey.shade50,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedLocation != null
                    ? Colors.blue.shade300
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
                      ? Colors.blue.shade600
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
                color: Colors.blue.shade50,
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: Colors.blue.shade200),
              ),
              child: Row(
                children: [
                  Icon(Icons.check_circle,
                      color: Colors.blue.shade600, size: 20),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Coordinates selected successfully',
                      style: TextStyle(
                        color: Colors.blue.shade700,
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
            : const Icon(Icons.save),
        label: Text(isLoading ? 'Updating Sale...' : 'Update Sale'),
        style: ElevatedButton.styleFrom(
          backgroundColor: isLoading ? Colors.grey : Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : () => _submitForm(saleProvider, uid),
      ),
    );
  }

  Widget _buildDeleteButton(SaleProvider saleProvider) {
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
            : const Icon(Icons.delete_outline),
        label: Text(isLoading ? 'Deleting...' : 'Delete Sale'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.red,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
        onPressed: isLoading ? null : () => _deleteSale(saleProvider),
      ),
    );
  }

  void _submitForm(SaleProvider saleProvider, String uid) {
    // Validate form
    if (!_formKey.currentState!.validate()) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all required fields correctly'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate sale data
    if (_loadedSale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No sale data available for update'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_loadedSale!.id == null || _loadedSale!.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid sale ID for update'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_selectedCarId == null || _selectedCarId!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a car'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate price
    final price = double.tryParse(_priceController.text);
    if (price == null || price <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid price'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate description
    if (_descriptionController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a description'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    // Validate that all required data is present
    if (uid.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid user ID'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isSubmitting = true;
    });

    debugPrint('EditSalePage: Starting sale update');
    debugPrint('EditSalePage: Sale ID: ${_loadedSale!.id}');
    debugPrint('EditSalePage: Car ID: $_selectedCarId');
    debugPrint('EditSalePage: Price: $price');
    debugPrint('EditSalePage: Status: $_status');
    debugPrint(
        'EditSalePage: Description: ${_descriptionController.text.trim()}');

    // Ensure we have valid data for all required fields
    final registration = _registrationController.text.trim();
    final inspectionReport = _inspectionReportController.text.trim();
    final description = _descriptionController.text.trim();

    debugPrint('EditSalePage: Registration: "$registration"');
    debugPrint('EditSalePage: Inspection Report: "$inspectionReport"');
    debugPrint('EditSalePage: Description: "$description"');

    final updatedSale = SaleModel(
      id: _loadedSale!.id, // Include the original ID for updates
      sellerId: uid,
      carId: _selectedCarId!,
      price: price,
      isAvailable: _isAvailable,
      status: _status,
      description: description,
      coordinates: {
        'latitude': _selectedLocation?.latitude ?? 25.2048,
        'longitude': _selectedLocation?.longitude ?? 55.2708,
      },
      documents: SaleDocumentsModel(
        registration: registration,
        inspectionReport: inspectionReport,
        lastMaintenanceDate: _lastMaintenanceDate ??
            DateTime.now().subtract(const Duration(days: 30)),
        nextMaintenanceDate: _nextMaintenanceDate ??
            DateTime.now().add(const Duration(days: 90)),
      ),
      statistics: _loadedSale!.statistics,
    );

    debugPrint('EditSalePage: Created updated sale model');
    debugPrint('EditSalePage: Updated sale ID: ${updatedSale.id}');
    debugPrint('EditSalePage: Updated sale sellerId: ${updatedSale.sellerId}');
    debugPrint('EditSalePage: Updated sale carId: ${updatedSale.carId}');
    debugPrint('EditSalePage: Updated sale price: ${updatedSale.price}');
    debugPrint('EditSalePage: Updated sale status: ${updatedSale.status}');
    debugPrint(
        'EditSalePage: Updated sale isAvailable: ${updatedSale.isAvailable}');

    // Debug the sale JSON
    try {
      final saleJson = updatedSale.toJson();
      debugPrint('EditSalePage: Sale JSON: $saleJson');
      debugPrint('EditSalePage: Sale JSON keys: ${saleJson.keys.toList()}');
    } catch (e) {
      debugPrint('EditSalePage: Error creating sale JSON: $e');
    }

    saleProvider.updateSale(_loadedSale!.id!, updatedSale).then((_) {
      if (!mounted) return;

      debugPrint('EditSalePage: Update operation completed');
      debugPrint(
          'EditSalePage: Update state: ${saleProvider.updateSaleState.runtimeType}');
      debugPrint('EditSalePage: Error message: ${saleProvider.errorMessage}');

      if (saleProvider.updateSaleState is DataSuccess) {
        debugPrint('EditSalePage: Sale updated successfully');

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
            content: Text('Sale listing updated successfully!'),
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
            'EditSalePage: Update failed with error: ${saleProvider.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to update sale: ${saleProvider.errorMessage}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        debugPrint('EditSalePage: Unexpected error occurred during update');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('An unexpected error occurred while updating the sale'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }).catchError((error) {
      if (!mounted) return;

      debugPrint('EditSalePage: Caught error during update: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error updating sale: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    });
  }

  void _deleteSale(SaleProvider saleProvider) {
    if (_loadedSale == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('No sale data available for deletion'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (_loadedSale!.id == null || _loadedSale!.id!.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid sale ID for deletion'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Confirm Deletion'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Are you sure you want to delete this sale listing?',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 8),
              Text(
                'Car: ${_loadedSale!.carId}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Price: \$${_loadedSale!.price}',
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'This action cannot be undone.',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.red,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          actions: <Widget>[
            TextButton(
              child: const Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              style: TextButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('Delete'),
              onPressed: () {
                Navigator.of(context).pop();
                _performDelete(saleProvider);
              },
            ),
          ],
        );
      },
    );
  }

  void _performDelete(SaleProvider saleProvider) {
    setState(() {
      _isSubmitting = true;
    });

    debugPrint('EditSalePage: Deleting sale with ID: ${_loadedSale!.id}');
    debugPrint('EditSalePage: Sale car ID: ${_loadedSale!.carId}');
    debugPrint('EditSalePage: Sale price: ${_loadedSale!.price}');

    saleProvider.deleteSale(_loadedSale!.id!).then((_) {
      if (!mounted) return;

      debugPrint('EditSalePage: Delete operation completed');
      debugPrint(
          'EditSalePage: Delete state: ${saleProvider.deleteSaleState.runtimeType}');
      debugPrint('EditSalePage: Error message: ${saleProvider.errorMessage}');

      if (saleProvider.deleteSaleState is DataSuccess) {
        debugPrint('EditSalePage: Sale deleted successfully');

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
            content: Text('Sale listing deleted successfully!'),
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
            'EditSalePage: Delete failed with error: ${saleProvider.errorMessage}');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content:
                Text('Failed to delete sale: ${saleProvider.errorMessage}'),
            backgroundColor: Colors.red,
            duration: const Duration(seconds: 4),
          ),
        );
      } else {
        debugPrint('EditSalePage: Unexpected error occurred during deletion');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content:
                Text('An unexpected error occurred while deleting the sale'),
            backgroundColor: Colors.red,
            duration: Duration(seconds: 3),
          ),
        );
      }

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }).catchError((error) {
      if (!mounted) return;

      debugPrint('EditSalePage: Caught error during deletion: $error');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error deleting sale: ${error.toString()}'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 4),
        ),
      );

      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    });
  }
}
