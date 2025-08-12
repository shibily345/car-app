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
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:car_app_beta/src/features/rental/data/models/rental_model.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/custom_button.dart';
import 'package:car_app_beta/src/widgets/inputs/styled_inputs.dart';
import 'package:car_app_beta/src/widgets/location_picker.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class UpdateRentalCarPage extends StatefulWidget {
  final String carId;
  const UpdateRentalCarPage({super.key, required this.carId});

  @override
  State<UpdateRentalCarPage> createState() => _UpdateRentalCarPageState();
}

class _UpdateRentalCarPageState extends State<UpdateRentalCarPage> {
  final _formKey = GlobalKey<FormState>();

  // Form controllers
  final _hourlyController = TextEditingController();
  final _dailyController = TextEditingController();
  final _weeklyController = TextEditingController();
  final _monthlyController = TextEditingController();
  final _minAgeController = TextEditingController(text: '21');
  final _insuranceCostController = TextEditingController();
  final _depositAmountController = TextEditingController();
  final _mileageLimitController = TextEditingController();
  final _overMileageChargeController = TextEditingController();
  final _cancellationFeeController = TextEditingController();
  final _childSeatCostController = TextEditingController();
  final _additionalDriverCostController = TextEditingController();
  final _roadsideAssistanceCostController = TextEditingController();
  final _winterTiresCostController = TextEditingController();

  // Form values
  String? _selectedCarId;
  String? _preselectedCarId;
  String _rentalType = 'daily';
  DateTime _availableFrom = DateTime.now();
  DateTime _availableTo = DateTime.now().add(const Duration(days: 365));
  bool _instantBooking = true;
  int _advanceBookingDays = 30;
  bool _sameAsPickup = true;
  int _minimumRentalPeriod = 1;
  int _maximumRentalPeriod = 30;
  LatLng? _pickupLatLng;
  String? _pickupAddress;
  LatLng? _dropoffLatLng;
  String? _dropoffAddress;

  // Terms
  bool _licenseRequired = true;
  bool _internationalLicense = false;
  bool _insuranceIncluded = false;
  bool _depositRequired = true;
  final int _mileageLimit = 0;
  String _fuelPolicy = 'full-to-full';
  String _cancellationPolicy = 'moderate';

  // Features
  bool _gps = true;
  bool _childSeat = false;
  bool _additionalDriver = true;
  bool _roadsideAssistance = true;
  bool _winterTires = false;

  // Operating hours
  String _pickupStart = '09:00';
  String _pickupEnd = '17:00';
  String _returnStart = '09:00';
  String _returnEnd = '17:00';
  bool _weekendPickup = true;
  bool _weekendReturn = true;

  bool _isSubmitting = false;
  bool _isLoadingRental = true;
  bool _hasFetchedRental = false;
  RentalEntity? _loadedRental;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_preselectedCarId == null) {
      final args = ModalRoute.of(context)?.settings.arguments;
      if (args != null && args is String) {
        _preselectedCarId = args;
        _selectedCarId = args;
      }
    }
    // Fetch rental details only once
    if (!_hasFetchedRental && _selectedCarId != null) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final rentalProvider =
          Provider.of<RentalProvider>(context, listen: false);
      if (userProvider.cSeller != null) {
        _hasFetchedRental = true;
        _loadRentalData(userProvider.cSeller!.id, rentalProvider);
      } else {
        setState(() {
          _isLoadingRental = false;
        });
      }
    }
  }

  Future<void> _loadRentalData(
      String sellerId, RentalProvider rentalProvider) async {
    try {
      setState(() {
        _isLoadingRental = true;
      });

      // Get seller rentals
      await rentalProvider.getSellerRentals(sellerId);

      debugPrint('Seller rentals state: ${rentalProvider.sellerRentalsState}');
      debugPrint('Looking for car ID: $_selectedCarId');

      // Try to find the rental by car ID
      final rental = rentalProvider.getRentalByCarId(_selectedCarId!);
      if (rental != null) {
        _fillFormFields(rental);
      } else {
        // If rental not found, show error
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text(
                  'Rental data not found for this car. Please check if the car is listed for rental.'),
              backgroundColor: Colors.red,
            ),
          );
        }
      }
    } catch (e) {
      debugPrint('Error loading rental data: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error loading rental data: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingRental = false;
        });
      }
    }
  }

  void _fillFormFields(RentalEntity rental) {
    setState(() {
      _loadedRental = rental;
      _rentalType = rental.rentalType;
      _hourlyController.text = rental.pricing.hourly?.toString() ?? '';
      _dailyController.text = rental.pricing.daily?.toString() ?? '';
      _weeklyController.text = rental.pricing.weekly?.toString() ?? '';
      _monthlyController.text = rental.pricing.monthly?.toString() ?? '';
      _minimumRentalPeriod = rental.pricing.minimumRentalPeriod;
      _maximumRentalPeriod = rental.pricing.maximumRentalPeriod;
      _availableFrom = rental.availability.availableFrom;
      _availableTo = rental.availability.availableTo;
      _instantBooking = rental.availability.instantBooking;
      _advanceBookingDays = rental.availability.advanceBookingDays;

      // Handle pickup location with null safety
      _pickupLatLng = LatLng(
        rental.pickupLocation.coordinates.latitude,
        rental.pickupLocation.coordinates.longitude,
      );
      _pickupAddress = rental.pickupLocation.address;

      _sameAsPickup = rental.returnLocation.sameAsPickup;

      // Handle return location with null safety
      _dropoffLatLng = LatLng(
        rental.returnLocation.coordinates.latitude,
        rental.returnLocation.coordinates.longitude,
      );
      _dropoffAddress = rental.returnLocation.address;

      _minAgeController.text = rental.terms.minimumAge.toString();
      _licenseRequired = rental.terms.licenseRequired;
      _internationalLicense = rental.terms.internationalLicense;
      _insuranceIncluded = rental.terms.insuranceIncluded;
      _insuranceCostController.text = rental.terms.insuranceCost.toString();
      _depositRequired = rental.terms.depositRequired;
      _depositAmountController.text = rental.terms.depositAmount.toString();
      _mileageLimitController.text = rental.terms.mileageLimit.toString();
      _overMileageChargeController.text =
          rental.terms.overMileageCharge.toString();
      _fuelPolicy = rental.terms.fuelPolicy;
      _cancellationPolicy = rental.terms.cancellationPolicy;
      _cancellationFeeController.text = rental.terms.cancellationFee.toString();
      _gps = rental.rentalFeatures.gps;
      _childSeat = rental.rentalFeatures.childSeat;
      _childSeatCostController.text =
          rental.rentalFeatures.childSeatCost.toString();
      _additionalDriver = rental.rentalFeatures.additionalDriver;
      _additionalDriverCostController.text =
          rental.rentalFeatures.additionalDriverCost.toString();
      _roadsideAssistance = rental.rentalFeatures.roadsideAssistance;
      _roadsideAssistanceCostController.text =
          rental.rentalFeatures.roadsideAssistanceCost.toString();
      _winterTires = rental.rentalFeatures.winterTires;
      _winterTiresCostController.text =
          rental.rentalFeatures.winterTiresCost.toString();
      _pickupStart = rental.operatingHours.pickupHours.start;
      _pickupEnd = rental.operatingHours.pickupHours.end;
      _returnStart = rental.operatingHours.returnHours.start;
      _returnEnd = rental.operatingHours.returnHours.end;
      _weekendPickup = rental.operatingHours.weekendHours.pickup;
      _weekendReturn = rental.operatingHours.weekendHours.return_;
    });
  }

  @override
  void dispose() {
    _hourlyController.dispose();
    _dailyController.dispose();
    _weeklyController.dispose();
    _monthlyController.dispose();
    _minAgeController.dispose();
    _insuranceCostController.dispose();
    _depositAmountController.dispose();
    _mileageLimitController.dispose();
    _overMileageChargeController.dispose();
    _cancellationFeeController.dispose();
    _childSeatCostController.dispose();
    _additionalDriverCostController.dispose();
    _roadsideAssistanceCostController.dispose();
    _winterTiresCostController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Rental Car'),
        backgroundColor: Colors.blue,
        foregroundColor: Colors.white,
      ),
      body: _isLoadingRental
          ? const Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 16),
                  Text(
                    'Loading rental data...',
                    style: TextStyle(fontSize: 16, color: Colors.grey),
                  ),
                ],
              ),
            )
          : _loadedRental == null
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.error_outline,
                          size: 60, color: Colors.red),
                      const SizedBox(height: 16),
                      const Text(
                        'Rental data not found!\nPlease check if this car is listed for rental.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 18, fontWeight: FontWeight.w500),
                      ),
                      const SizedBox(height: 16),
                      const Text(
                        'If you believe this is an error, please try refreshing the page.',
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14, color: Colors.grey),
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          setState(() {
                            _hasFetchedRental = false;
                            _isLoadingRental = true;
                          });
                          final userProvider =
                              Provider.of<UserProvider>(context, listen: false);
                          final rentalProvider = Provider.of<RentalProvider>(
                              context,
                              listen: false);
                          if (userProvider.cSeller != null) {
                            _loadRentalData(
                                userProvider.cSeller!.id, rentalProvider);
                          }
                        },
                        icon: const Icon(Icons.refresh),
                        label: const Text('Retry'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue,
                          foregroundColor: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ],
                  ),
                )
              : Consumer3<UserProvider, CarsProvider, RentalProvider>(
                  builder:
                      (context, userProvider, carsProvider, rentalProvider, _) {
                    if (userProvider.firebaseUser == null) {
                      return const Center(
                          child: Text('Please log in to add a rental car.'));
                    }
                    if (carsProvider.cars == null) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final String id = userProvider.cSeller!.id;
                    // final String uid = userProvider.firebaseUser!.uid;
                    final List<CarEntity> userCars = carsProvider.cars!
                        .where((car) => car.sellerId == id)
                        .toList();

                    if (userCars.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Icon(Icons.directions_car,
                                size: 60, color: Colors.blue),
                            const SizedBox(height: 16),
                            const Text(
                              'No cars found!\nAdd a car to your garage before listing for rental.',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.w500),
                            ),
                            const SizedBox(height: 24),
                            ElevatedButton.icon(
                              onPressed: () =>
                                  Navigator.pushNamed(context, '/addNew'),
                              icon: const Icon(Icons.add),
                              label: const Text('Add Car'),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blue,
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

                    return RefreshIndicator(
                      onRefresh: () async {
                        final userProvider =
                            Provider.of<UserProvider>(context, listen: false);
                        final rentalProvider =
                            Provider.of<RentalProvider>(context, listen: false);
                        if (userProvider.cSeller != null) {
                          await _loadRentalData(
                              userProvider.cSeller!.id, rentalProvider);
                        }
                      },
                      child: Form(
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
                                _buildSectionTitle('Rental Type'),
                                _buildRentalTypeSelector(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Pricing'),
                                _buildPricingSection(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Availability'),
                                _buildAvailabilitySection(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Pickup Location'),
                                _buildLocationSection(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Terms & Conditions'),
                                _buildTermsSection(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Additional Features'),
                                _buildFeaturesSection(),
                              ]),
                              const SpaceY(16),
                              _buildSectionCard([
                                _buildSectionTitle('Operating Hours'),
                                _buildOperatingHoursSection(),
                              ]),
                              const SpaceY(24),
                              _isSubmitting || rentalProvider.isLoading
                                  ? const Center(
                                      child: CircularProgressIndicator())
                                  : Column(
                                      children: [
                                        _buildUpdateButton(rentalProvider, id),
                                        if (_loadedRental != null &&
                                            _loadedRental!.id != null)
                                          Padding(
                                            padding: const EdgeInsets.only(
                                                top: 16.0),
                                            child: SizedBox(
                                              width: double.infinity,
                                              child: ElevatedButton.icon(
                                                icon: const Icon(Icons.delete,
                                                    color: Colors.white),
                                                label: const Text(
                                                  'Delete Rental Listing',
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      color: Colors.white),
                                                ),
                                                style: ElevatedButton.styleFrom(
                                                  backgroundColor: Colors.red,
                                                  foregroundColor: Colors.white,
                                                  padding: const EdgeInsets
                                                      .symmetric(vertical: 16),
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              12)),
                                                ),
                                                onPressed: () async {
                                                  final confirm =
                                                      await showDialog<bool>(
                                                    context: context,
                                                    builder: (context) =>
                                                        AlertDialog(
                                                      title: const Text(
                                                          'Delete Rental'),
                                                      content: const Text(
                                                          'Are you sure you want to delete this rental listing?'),
                                                      actions: [
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(false),
                                                          child: const Text(
                                                              'Cancel'),
                                                        ),
                                                        TextButton(
                                                          onPressed: () =>
                                                              Navigator.of(
                                                                      context)
                                                                  .pop(true),
                                                          child: const Text(
                                                              'Delete',
                                                              style: TextStyle(
                                                                  color: Colors
                                                                      .red)),
                                                        ),
                                                      ],
                                                    ),
                                                  );
                                                  if (confirm == true) {
                                                    if (_loadedRental!.id !=
                                                        null) {
                                                      debugPrint(
                                                          '--------------------');
                                                    }
                                                    final result =
                                                        await rentalProvider
                                                            .deleteRental(
                                                                _loadedRental!
                                                                    .id!,
                                                                context);
                                                    debugPrint(
                                                        'result: $result');
                                                    if (mounted) {
                                                      if (result
                                                          is DataSuccess) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Rental deleted successfully!')),
                                                        );
                                                        final carsProvider =
                                                            Provider.of<
                                                                    CarsProvider>(
                                                                context,
                                                                listen: false);
                                                        final rentalProvider =
                                                            Provider.of<
                                                                    RentalProvider>(
                                                                context,
                                                                listen: false);

                                                        // Refresh cars, rentals, and sales data
                                                        carsProvider
                                                            .eitherFailureOrCars();
                                                        rentalProvider
                                                            .getAllRentals();
                                                        Navigator.of(context)
                                                            .pop();
                                                      } else if (result
                                                          is DataFailed) {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          SnackBar(
                                                              content: Text(
                                                                  rentalProvider
                                                                          .errorMessage ??
                                                                      'Failed to delete rental')),
                                                        );
                                                      } else {
                                                        ScaffoldMessenger.of(
                                                                context)
                                                            .showSnackBar(
                                                          const SnackBar(
                                                              content: Text(
                                                                  'Not Working......')),
                                                        );
                                                      }
                                                    }
                                                  }
                                                },
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                            ],
                          ),
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
          color: Colors.blue,
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
                color: isPreselected ? Colors.green : Colors.blue,
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

  Widget _buildRentalTypeSelector() {
    return Column(
      children: [
        RadioListTile<String>(
          title: const Text('Hourly'),
          value: 'hourly',
          groupValue: _rentalType,
          onChanged: (value) {
            setState(() {
              _rentalType = value!;
              _hourlyController.text = '';
              _dailyController.text = '0';
              _weeklyController.text = '0';
              _monthlyController.text = '0';
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Daily'),
          value: 'daily',
          groupValue: _rentalType,
          onChanged: (value) {
            setState(() {
              _rentalType = value!;
              _hourlyController.text = '0';
              _dailyController.text = '';
              _weeklyController.text = '0';
              _monthlyController.text = '0';
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Weekly'),
          value: 'weekly',
          groupValue: _rentalType,
          onChanged: (value) {
            setState(() {
              _rentalType = value!;
              _hourlyController.text = '0';
              _dailyController.text = '0';
              _weeklyController.text = '';
              _monthlyController.text = '0';
            });
          },
        ),
        RadioListTile<String>(
          title: const Text('Monthly'),
          value: 'monthly',
          groupValue: _rentalType,
          onChanged: (value) {
            setState(() {
              _rentalType = value!;
              _hourlyController.text = '0';
              _dailyController.text = '0';
              _weeklyController.text = '0';
              _monthlyController.text = '';
            });
          },
        ),
      ],
    );
  }

  Widget _buildPricingSection() {
    List<Widget> fields = [];
    if (_rentalType == 'hourly') {
      fields.add(StyledTextField(
        controller: _hourlyController,
        label: 'Hourly Rate ( 24)',
        keyboardType: TextInputType.number,
      ));
    }
    if (_rentalType == 'daily') {
      fields.add(StyledTextField(
        controller: _dailyController,
        label: 'Daily Rate ( 24)',
        keyboardType: TextInputType.number,
      ));
    }
    if (_rentalType == 'weekly') {
      fields.add(StyledTextField(
        controller: _weeklyController,
        label: 'Weekly Rate ( 24)',
        keyboardType: TextInputType.number,
      ));
    }
    if (_rentalType == 'monthly') {
      fields.add(StyledTextField(
        controller: _monthlyController,
        label: 'Monthly Rate ( 24)',
        keyboardType: TextInputType.number,
      ));
    }
    fields.add(const SpaceY(10));
    fields.add(Row(
      children: [
        Expanded(
          child: StyledTextField(
            hint: _minimumRentalPeriod.toString(),
            label: 'Min Rental Period (days)',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _minimumRentalPeriod = int.tryParse(value) ?? 1;
            },
          ),
        ),
        const SpaceX(10),
        Expanded(
          child: StyledTextField(
            hint: _maximumRentalPeriod.toString(),
            label: 'Max Rental Period (days)',
            keyboardType: TextInputType.number,
            onChanged: (value) {
              _maximumRentalPeriod = int.tryParse(value) ?? 30;
            },
          ),
        ),
      ],
    ));
    return Column(children: fields);
  }

  Widget _buildAvailabilitySection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ListTile(
                title: const Text('Available From'),
                subtitle: Text(_availableFrom.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _availableFrom,
                    firstDate: DateTime.now(),
                    lastDate: DateTime.now().add(const Duration(days: 365)),
                  );
                  if (date != null) {
                    setState(() {
                      _availableFrom = date;
                    });
                  }
                },
              ),
            ),
            Expanded(
              child: ListTile(
                title: const Text('Available To'),
                subtitle: Text(_availableTo.toString().split(' ')[0]),
                trailing: const Icon(Icons.calendar_today),
                onTap: () async {
                  final date = await showDatePicker(
                    context: context,
                    initialDate: _availableTo,
                    firstDate: _availableFrom,
                    lastDate: DateTime.now().add(const Duration(days: 730)),
                  );
                  if (date != null) {
                    setState(() {
                      _availableTo = date;
                    });
                  }
                },
              ),
            ),
          ],
        ),
        CheckboxListTile(
          title: const Text('Instant Booking Available'),
          value: _instantBooking,
          onChanged: (value) {
            setState(() {
              _instantBooking = value ?? true;
            });
          },
        ),
        StyledTextField(
          hint: _advanceBookingDays.toString(),
          label: 'Advance Booking Days',
          keyboardType: TextInputType.number,
          onChanged: (value) {
            _advanceBookingDays = int.tryParse(value) ?? 30;
          },
        ),
      ],
    );
  }

  Widget _buildLocationSection() {
    return Column(
      children: [
        ListTile(
          leading: const Icon(Icons.location_on, color: Colors.blue),
          title: Text(_pickupAddress ?? 'Select Pickup Location'),
          subtitle: _pickupLatLng != null
              ? Text(
                  'Lat: ${_pickupLatLng!.latitude}, Lng: ${_pickupLatLng!.longitude}')
              : null,
          onTap: () async {
            final result = await Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => LocationPicker(
                  initialLocation: _pickupLatLng,
                  title: 'Select Pickup Location',
                  onLocationSelected: (latLng, address) {
                    setState(() {
                      _pickupLatLng = latLng;
                      _pickupAddress = address;
                      if (_sameAsPickup) {
                        _dropoffLatLng = latLng;
                        _dropoffAddress = address;
                      }
                    });
                  },
                ),
              ),
            );
          },
        ),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Same as Pickup'),
                value: _sameAsPickup,
                onChanged: (value) {
                  setState(() {
                    _sameAsPickup = value ?? true;
                    if (_sameAsPickup && _pickupLatLng != null) {
                      _dropoffLatLng = _pickupLatLng;
                      _dropoffAddress = _pickupAddress;
                    }
                  });
                },
              ),
            ),
          ],
        ),
        if (!_sameAsPickup)
          ListTile(
            leading: const Icon(Icons.location_on, color: Colors.green),
            title: Text(_dropoffAddress ?? 'Select Drop-off Location'),
            subtitle: _dropoffLatLng != null
                ? Text(
                    'Lat: ${_dropoffLatLng!.latitude}, Lng: ${_dropoffLatLng!.longitude}')
                : null,
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => LocationPicker(
                    initialLocation: _dropoffLatLng,
                    title: 'Select Drop-off Location',
                    onLocationSelected: (latLng, address) {
                      setState(() {
                        _dropoffLatLng = latLng;
                        _dropoffAddress = address;
                      });
                    },
                  ),
                ),
              );
            },
          ),
      ],
    );
  }

  Widget _buildTermsSection() {
    return Column(
      children: [
        StyledTextField(
          controller: _minAgeController,
          label: 'Minimum Age',
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter minimum age';
            }
            return null;
          },
        ),
        const SpaceY(10),
        CheckboxListTile(
          title: const Text('License Required'),
          value: _licenseRequired,
          onChanged: (value) {
            setState(() {
              _licenseRequired = value ?? true;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('International License Accepted'),
          value: _internationalLicense,
          onChanged: (value) {
            setState(() {
              _internationalLicense = value ?? false;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Insurance Included'),
          value: _insuranceIncluded,
          onChanged: (value) {
            setState(() {
              _insuranceIncluded = value ?? false;
            });
          },
        ),
        if (!_insuranceIncluded)
          StyledTextField(
            controller: _insuranceCostController,
            label: 'Insurance Cost per Day (\$)',
            keyboardType: TextInputType.number,
          ),
        const SpaceY(10),
        CheckboxListTile(
          title: const Text('Deposit Required'),
          value: _depositRequired,
          onChanged: (value) {
            setState(() {
              _depositRequired = value ?? true;
            });
          },
        ),
        if (_depositRequired)
          StyledTextField(
            controller: _depositAmountController,
            label: 'Deposit Amount (\$)',
            keyboardType: TextInputType.number,
          ),
        const SpaceY(10),
        Row(
          children: [
            Expanded(
              child: StyledTextField(
                controller: _mileageLimitController,
                label: 'Mileage Limit (0 = unlimited)',
                keyboardType: TextInputType.number,
              ),
            ),
            const SpaceX(10),
            Expanded(
              child: StyledTextField(
                controller: _overMileageChargeController,
                label: 'Over Mileage Charge (\$/mile)',
                keyboardType: TextInputType.number,
              ),
            ),
          ],
        ),
        const SpaceY(10),
        DropdownButtonFormField<String>(
          value: _fuelPolicy,
          decoration: const InputDecoration(
            labelText: 'Fuel Policy',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(
                value: 'full-to-full', child: Text('Full to Full')),
            DropdownMenuItem(
                value: 'full-to-empty', child: Text('Full to Empty')),
            DropdownMenuItem(value: 'prepaid', child: Text('Prepaid')),
          ],
          onChanged: (value) {
            setState(() {
              _fuelPolicy = value!;
            });
          },
        ),
        const SpaceY(10),
        DropdownButtonFormField<String>(
          value: _cancellationPolicy,
          decoration: const InputDecoration(
            labelText: 'Cancellation Policy',
            border: OutlineInputBorder(),
          ),
          items: const [
            DropdownMenuItem(value: 'flexible', child: Text('Flexible')),
            DropdownMenuItem(value: 'moderate', child: Text('Moderate')),
            DropdownMenuItem(value: 'strict', child: Text('Strict')),
          ],
          onChanged: (value) {
            setState(() {
              _cancellationPolicy = value!;
            });
          },
        ),
        const SpaceY(10),
        StyledTextField(
          controller: _cancellationFeeController,
          label: 'Cancellation Fee (\$)',
          keyboardType: TextInputType.number,
        ),
      ],
    );
  }

  Widget _buildFeaturesSection() {
    return Column(
      children: [
        CheckboxListTile(
          title: const Text('GPS Navigation'),
          value: _gps,
          onChanged: (value) {
            setState(() {
              _gps = value ?? true;
            });
          },
        ),
        CheckboxListTile(
          title: const Text('Child Seat Available'),
          value: _childSeat,
          onChanged: (value) {
            setState(() {
              _childSeat = value ?? false;
            });
          },
        ),
        if (_childSeat)
          StyledTextField(
            controller: _childSeatCostController,
            label: 'Child Seat Cost per Day (\$)',
            keyboardType: TextInputType.number,
          ),
        CheckboxListTile(
          title: const Text('Additional Driver Available'),
          value: _additionalDriver,
          onChanged: (value) {
            setState(() {
              _additionalDriver = value ?? true;
            });
          },
        ),
        if (_additionalDriver)
          StyledTextField(
            controller: _additionalDriverCostController,
            label: 'Additional Driver Cost per Day (\$)',
            keyboardType: TextInputType.number,
          ),
        CheckboxListTile(
          title: const Text('Roadside Assistance'),
          value: _roadsideAssistance,
          onChanged: (value) {
            setState(() {
              _roadsideAssistance = value ?? true;
            });
          },
        ),
        if (_roadsideAssistance)
          StyledTextField(
            controller: _roadsideAssistanceCostController,
            label: 'Roadside Assistance Cost per Day (\$)',
            keyboardType: TextInputType.number,
          ),
        CheckboxListTile(
          title: const Text('Winter Tires Available'),
          value: _winterTires,
          onChanged: (value) {
            setState(() {
              _winterTires = value ?? false;
            });
          },
        ),
        if (_winterTires)
          StyledTextField(
            controller: _winterTiresCostController,
            label: 'Winter Tires Cost per Day (\$)',
            keyboardType: TextInputType.number,
          ),
      ],
    );
  }

  Widget _buildOperatingHoursSection() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _pickupStart,
                decoration: const InputDecoration(
                  labelText: 'Pickup Start Time',
                  border: OutlineInputBorder(),
                ),
                items: _generateTimeOptions(),
                onChanged: (value) {
                  setState(() {
                    _pickupStart = value!;
                  });
                },
              ),
            ),
            const SpaceX(10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _pickupEnd,
                decoration: const InputDecoration(
                  labelText: 'Pickup End Time',
                  border: OutlineInputBorder(),
                ),
                items: _generateTimeOptions(),
                onChanged: (value) {
                  setState(() {
                    _pickupEnd = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SpaceY(10),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _returnStart,
                decoration: const InputDecoration(
                  labelText: 'Return Start Time',
                  border: OutlineInputBorder(),
                ),
                items: _generateTimeOptions(),
                onChanged: (value) {
                  setState(() {
                    _returnStart = value!;
                  });
                },
              ),
            ),
            const SpaceX(10),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _returnEnd,
                decoration: const InputDecoration(
                  labelText: 'Return End Time',
                  border: OutlineInputBorder(),
                ),
                items: _generateTimeOptions(),
                onChanged: (value) {
                  setState(() {
                    _returnEnd = value!;
                  });
                },
              ),
            ),
          ],
        ),
        const SpaceY(10),
        Row(
          children: [
            Expanded(
              child: CheckboxListTile(
                title: const Text('Weekend Pickup'),
                value: _weekendPickup,
                onChanged: (value) {
                  setState(() {
                    _weekendPickup = value ?? true;
                  });
                },
              ),
            ),
            Expanded(
              child: CheckboxListTile(
                title: const Text('Weekend Return'),
                value: _weekendReturn,
                onChanged: (value) {
                  setState(() {
                    _weekendReturn = value ?? true;
                  });
                },
              ),
            ),
          ],
        ),
      ],
    );
  }

  List<DropdownMenuItem<String>> _generateTimeOptions() {
    final times = <String>[];
    for (int hour = 0; hour < 24; hour++) {
      for (int minute = 0; minute < 60; minute += 30) {
        final time =
            '${hour.toString().padLeft(2, '0')}:${minute.toString().padLeft(2, '0')}';
        times.add(time);
      }
    }
    return times
        .map((time) => DropdownMenuItem(value: time, child: Text(time)))
        .toList();
  }

  Widget _buildUpdateButton(RentalProvider rentalProvider, String uid) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton.icon(
        icon: const Icon(Icons.check_circle, color: Colors.white),
        label: const Text(
          'Update Rental Listing',
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: rentalProvider.isLoading ||
                _isSubmitting ||
                _loadedRental == null
            ? null
            : () async {
                setState(() => _isSubmitting = true);
                await Future.delayed(const Duration(milliseconds: 300));
                if (!_formKey.currentState!.validate()) {
                  setState(() => _isSubmitting = false);
                  return;
                }
                if (_selectedCarId == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Please select a car')),
                  );
                  setState(() => _isSubmitting = false);
                  return;
                }
                if (_pickupLatLng == null || _pickupAddress == null) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a pickup location')),
                  );
                  setState(() => _isSubmitting = false);
                  return;
                }
                if (!_sameAsPickup &&
                    (_dropoffLatLng == null || _dropoffAddress == null)) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                        content: Text('Please select a drop-off location')),
                  );
                  setState(() => _isSubmitting = false);
                  return;
                }
                final updatedRental = RentalModel(
                  id: _loadedRental!.id,
                  sellerId: uid,
                  carId: _selectedCarId!,
                  rentalType: _rentalType,
                  pricing: RentalPricingModel(
                    hourly: double.tryParse(_hourlyController.text),
                    daily: double.tryParse(_dailyController.text),
                    weekly: double.tryParse(_weeklyController.text),
                    monthly: double.tryParse(_monthlyController.text),
                    minimumRentalPeriod: _minimumRentalPeriod,
                    maximumRentalPeriod: _maximumRentalPeriod,
                  ),
                  availability: RentalAvailabilityModel(
                    isAvailable: true,
                    availableFrom: _availableFrom,
                    availableTo: _availableTo,
                    instantBooking: _instantBooking,
                    advanceBookingDays: _advanceBookingDays,
                  ),
                  pickupLocation: RentalLocationModel(
                    address: _pickupAddress!,
                    city: '',
                    state: '',
                    zipCode: '',
                    coordinates: RentalCoordinatesModel(
                      latitude: _pickupLatLng!.latitude,
                      longitude: _pickupLatLng!.longitude,
                    ),
                    sameAsPickup: false,
                  ),
                  returnLocation: RentalLocationModel(
                    address: _sameAsPickup ? _pickupAddress! : _dropoffAddress!,
                    city: '',
                    state: '',
                    zipCode: '',
                    coordinates: RentalCoordinatesModel(
                      latitude: _sameAsPickup
                          ? _pickupLatLng!.latitude
                          : _dropoffLatLng!.latitude,
                      longitude: _sameAsPickup
                          ? _pickupLatLng!.longitude
                          : _dropoffLatLng!.longitude,
                    ),
                    sameAsPickup: _sameAsPickup,
                  ),
                  terms: RentalTermsModel(
                    minimumAge: int.parse(_minAgeController.text),
                    licenseRequired: _licenseRequired,
                    internationalLicense: _internationalLicense,
                    insuranceIncluded: _insuranceIncluded,
                    insuranceCost:
                        double.tryParse(_insuranceCostController.text) ?? 0,
                    depositRequired: _depositRequired,
                    depositAmount:
                        double.tryParse(_depositAmountController.text) ?? 0,
                    mileageLimit:
                        int.tryParse(_mileageLimitController.text) ?? 0,
                    overMileageCharge:
                        double.tryParse(_overMileageChargeController.text) ?? 0,
                    fuelPolicy: _fuelPolicy,
                    cancellationPolicy: _cancellationPolicy,
                    cancellationFee:
                        double.tryParse(_cancellationFeeController.text) ?? 0,
                  ),
                  rentalFeatures: RentalFeaturesModel(
                    gps: _gps,
                    childSeat: _childSeat,
                    childSeatCost:
                        double.tryParse(_childSeatCostController.text) ?? 0,
                    additionalDriver: _additionalDriver,
                    additionalDriverCost:
                        double.tryParse(_additionalDriverCostController.text) ??
                            0,
                    roadsideAssistance: _roadsideAssistance,
                    roadsideAssistanceCost: double.tryParse(
                            _roadsideAssistanceCostController.text) ??
                        0,
                    winterTires: _winterTires,
                    winterTiresCost:
                        double.tryParse(_winterTiresCostController.text) ?? 0,
                  ),
                  operatingHours: RentalOperatingHoursModel(
                    pickupHours: RentalHoursModel(
                      start: _pickupStart,
                      end: _pickupEnd,
                    ),
                    returnHours: RentalHoursModel(
                      start: _returnStart,
                      end: _returnEnd,
                    ),
                    weekendHours: RentalWeekendHoursModel(
                      pickup: _weekendPickup,
                      return_: _weekendReturn,
                    ),
                  ),
                  status: _loadedRental!.status,
                  createdAt: _loadedRental!.createdAt,
                  updatedAt: DateTime.now(),
                );
                final result = await rentalProvider.updateRental(
                    _loadedRental!.id!, updatedRental, context);
                debugPrint('updateRental result: $result');
                setState(() => _isSubmitting = false);
                if (result != null && result is DataSuccess) {
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                          content: Text('Rental updated successfully!')),
                    );
                    final carsProvider =
                        Provider.of<CarsProvider>(context, listen: false);
                    final rentalProvider =
                        Provider.of<RentalProvider>(context, listen: false);

                    // Refresh cars, rentals, and sales data
                    carsProvider.eitherFailureOrCars();
                    rentalProvider.getAllRentals();
                    Navigator.of(context).pop();
                  }
                } else {
                  String errorMsg = 'Failed to update rental';
                  if (result is DataFailed) {
                    final err = result?.error;
                    if (err != null && err.message != null) {
                      errorMsg = err.message!;
                    }
                  }
                  if (mounted) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(errorMsg)),
                    );
                  }
                }
              },
      ),
    );
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
