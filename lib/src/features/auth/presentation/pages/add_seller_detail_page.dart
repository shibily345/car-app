import 'dart:io';

import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:car_app_beta/src/widgets/location_picker.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:geocoding/geocoding.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:provider/provider.dart';

class AddSellerDetailPage extends StatefulWidget {
  const AddSellerDetailPage({super.key});
  static const routeName = '/sellerDetails';

  @override
  State<AddSellerDetailPage> createState() => _AddSellerDetailPageState();
}

class _AddSellerDetailPageState extends State<AddSellerDetailPage>
    with TickerProviderStateMixin {
  // Controllers
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  // Animation controllers
  AnimationController? _fadeController;
  AnimationController? _slideController;
  Animation<double>? _fadeAnimation;
  Animation<Offset>? _slideAnimation;

  // State variables
  Country _selectedCountry = Country.parse("in"); // Default to India
  bool _isLoading = false;
  LatLng? _selectedLocation;
  String? _locationAddress;
  final TextEditingController _locationEditController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _initializeAnimations();
    _initializeFormData();
    _setupFormValidation();
  }

  void _initializeAnimations() {
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _fadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(
      parent: _fadeController!,
      curve: Curves.easeInOut,
    ));

    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.3),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: _slideController!,
      curve: Curves.easeOutCubic,
    ));

    _fadeController?.forward();
    _slideController?.forward();
  }

  void _initializeFormData() {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = userProvider.firebaseUser?.displayName ?? '';
    _emailController.text = userProvider.firebaseUser?.email ?? '';
    _phoneController.text = "+${_selectedCountry.phoneCode}";
  }

  void _setupFormValidation() {
    _nameController.addListener(_validateForm);
    _phoneController.addListener(_validateForm);
    _emailController.addListener(_validateForm);
  }

  void _validateForm() {
    // Remove real-time validation to make form more user-friendly
    // Validation will happen on submit
  }

  @override
  void dispose() {
    _fadeController?.dispose();
    _slideController?.dispose();
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    _locationEditController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: _fadeAnimation != null && _slideAnimation != null
            ? FadeTransition(
                opacity: _fadeAnimation!,
                child: SlideTransition(
                  position: _slideAnimation!,
                  child: _buildContent(theme, screenSize),
                ),
              )
            : _buildContent(theme, screenSize),
      ),
    );
  }

  Widget _buildContent(ThemeData theme, Size screenSize) {
    return CustomScrollView(
      slivers: [
        _buildAppBar(theme, screenSize),
        SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.w),
            child: Form(
              key: _formKey,
              child: Column(
                children: [
                  verticalSpaceLarge,
                  _buildProfileSection(),
                  verticalSpaceLarge,
                  _buildFormSection(),
                  verticalSpaceLarge,
                  _buildSubmitButton(),
                  verticalSpaceLarge,
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildAppBar(ThemeData theme, Size screenSize) {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      flexibleSpace: FlexibleSpaceBar(
        title: Text(
          'Complete Your Profile',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 20.sp,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.primaryColor.withValues(alpha: 0.1),
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
      leading: IconButton(
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: theme.colorScheme.onSurface,
            size: 20,
          ),
        ),
        onPressed: () => Navigator.of(context).pop(),
      ),
    );
  }

  Widget _buildProfileSection() {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final image = userProvider.hasImage && userProvider.image != null
            ? FileImage(File(userProvider.image!.path))
            : userProvider.firebaseUser?.photoURL != null
                ? NetworkImage(userProvider.firebaseUser!.photoURL!)
                : null;

        return Column(
          children: [
            GestureDetector(
              onTap: () => _showImagePickerDialog(userProvider),
              child: Container(
                width: 100.w,
                height: 100.w,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.1),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Stack(
                  children: [
                    CircleAvatar(
                      radius: 50.w,
                      backgroundImage: image as ImageProvider?,
                      backgroundColor: Colors.grey[200],
                      child: image == null
                          ? Icon(
                              Icons.person,
                              size: 50.w,
                              color: Colors.grey[400],
                            )
                          : null,
                    ),
                    Positioned(
                      bottom: 0,
                      right: 0,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withValues(alpha: 0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20.w,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            verticalSpaceMedium,
            Text(
              'Tap to change photo',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildFormSection() {
    return Column(
      children: [
        _buildAnimatedTextField(
          controller: _nameController,
          label: 'Name of the Dealership',
          icon: Icons.person_outline,
          validator: _validateName,
          textInputAction: TextInputAction.next,
        ),
        verticalSpaceMedium,
        _buildPhoneField(),
        verticalSpaceMedium,
        _buildLocationPicker(),
        verticalSpaceMedium,
        _buildAnimatedTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email_outlined,
          validator: _validateEmail,
          keyboardType: TextInputType.emailAddress,
          textInputAction: TextInputAction.done,
        ),
      ],
    );
  }

  Widget _buildAnimatedTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
    TextInputAction? textInputAction,
  }) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType,
        textInputAction: textInputAction,
        style: TextStyle(
          fontSize: 14.sp,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(
            icon,
            color: Colors.grey[600],
            size: 20.w,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.grey[300]!),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(color: Colors.red[300]!),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Colors.red, width: 2),
          ),
          filled: true,
          fillColor: Colors.grey[50],
          contentPadding: EdgeInsets.symmetric(
            horizontal: 16.w,
            vertical: 14.h,
          ),
          labelStyle: TextStyle(
            color: Colors.grey[600],
            fontSize: 14.sp,
            fontWeight: FontWeight.w500,
          ),
        ),
        validator: validator,
      ),
    );
  }

  Widget _buildPhoneField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildCountryPicker(),
        verticalSpaceSmall,
        _buildAnimatedTextField(
          controller: _phoneController,
          label: 'Phone Number',
          icon: Icons.phone_outlined,
          validator: _validatePhone,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
        ),
      ],
    );
  }

  Widget _buildLocationPicker() {
    // Debug print to see current state values
    debugPrint('=== LOCATION DISPLAY WIDGET ===');
    debugPrint('_selectedLocation: $_selectedLocation');
    debugPrint('_locationAddress: "$_locationAddress"');
    debugPrint('================================');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Location',
          style: TextStyle(
            fontSize: 14.sp,
            fontWeight: FontWeight.w600,
            color: Colors.grey[700],
          ),
        ),
        verticalSpaceSmall,
        GestureDetector(
          onTap: () => _showLocationPicker(),
          child: Container(
            width: double.infinity,
            padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
            decoration: BoxDecoration(
              color: _selectedLocation != null
                  ? Colors.green[50]
                  : Colors.grey[50],
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: _selectedLocation != null
                    ? Colors.green[300]!
                    : Colors.grey[300]!,
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
                      ? Colors.green[600]
                      : Colors.grey[600],
                  size: 20.w,
                ),
                horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    _selectedLocation != null
                        ? (_locationAddress ?? 'Converting coordinates...')
                        : 'Select Location',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w500,
                      color: _selectedLocation != null
                          ? Colors.black
                          : Colors.grey[600],
                    ),
                  ),
                ),
                Icon(
                  Icons.arrow_forward_ios,
                  color: Colors.grey[600],
                  size: 16.w,
                ),
              ],
            ),
          ),
        ),
        if (_selectedLocation != null)
          Padding(
            padding: EdgeInsets.only(top: 8.h),
            child: Text(
              'Coordinates: ${_selectedLocation!.latitude.toStringAsFixed(6)}, ${_selectedLocation!.longitude.toStringAsFixed(6)}',
              style: TextStyle(
                fontSize: 12.sp,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ),
      ],
    );
  }

  Widget _buildCountryPicker() {
    return SizedBox(
      width: double.infinity,
      child: PopupMenuButton<String>(
        onSelected: (String countryCode) {
          setState(() {
            if (countryCode == 'in') {
              _selectedCountry = Country.parse('in');
            } else if (countryCode == 'ae') {
              _selectedCountry = Country.parse('ae');
            } else {
              _showCountryPicker();
            }
            _phoneController.text = "+${_selectedCountry.phoneCode}";
          });
        },
        child: Container(
          width: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 16.w, vertical: 14.h),
          decoration: BoxDecoration(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    _selectedCountry.flagEmoji,
                    style: TextStyle(fontSize: 18.sp),
                  ),
                  horizontalSpaceSmall,
                  Text(
                    '+${_selectedCountry.phoneCode}',
                    style: TextStyle(
                      fontSize: 14.sp,
                      fontWeight: FontWeight.w600,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
              Icon(
                Icons.keyboard_arrow_down,
                color: Theme.of(context).primaryColor,
                size: 18.w,
              ),
            ],
          ),
        ),
        itemBuilder: (BuildContext context) => [
          PopupMenuItem<String>(
            value: 'in',
            child: Row(
              children: [
                Text('🇮🇳', style: TextStyle(fontSize: 18.sp)),
                horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    'India (+91)',
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'ae',
            child: Row(
              children: [
                Text('🇦🇪', style: TextStyle(fontSize: 18.sp)),
                horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    'UAE (+971)',
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
          PopupMenuItem<String>(
            value: 'other',
            child: Row(
              children: [
                Icon(Icons.public, size: 18.w, color: Colors.grey[600]),
                horizontalSpaceSmall,
                Expanded(
                  child: Text(
                    'Other Countries',
                    style: TextStyle(fontSize: 14.sp),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      height: 52.h,
      child: ElevatedButton(
        onPressed: _isLoading ? null : _handleSubmit,
        style: ElevatedButton.styleFrom(
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
          elevation: 8,
          shadowColor: Theme.of(context).primaryColor.withValues(alpha: 0.3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          disabledBackgroundColor: Colors.grey[400],
        ),
        child: _isLoading
            ? SizedBox(
                width: 20.w,
                height: 20.w,
                child: const CircularProgressIndicator(
                  strokeWidth: 2,
                  valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                ),
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.check_circle_outline,
                    size: 20.w,
                  ),
                  horizontalSpaceSmall,
                  Flexible(
                    child: Text(
                      'Complete Profile',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w600,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
      ),
    );
  }

  void _showImagePickerDialog(UserProvider userProvider) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(20),
            topRight: Radius.circular(20),
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              margin: EdgeInsets.only(top: 8.h),
              width: 40.w,
              height: 4.h,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            verticalSpaceMedium,
            Text(
              'Choose Photo',
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.bold,
              ),
            ),
            verticalSpaceMedium,
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.w),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    child: _buildImageOption(
                      icon: Icons.camera_alt,
                      label: 'Camera',
                      onTap: () {
                        Navigator.pop(context);
                        userProvider.pickImage();
                      },
                    ),
                  ),
                  horizontalSpaceMedium,
                  Expanded(
                    child: _buildImageOption(
                      icon: Icons.photo_library,
                      label: 'Gallery',
                      onTap: () {
                        Navigator.pop(context);
                        userProvider.pickImage();
                      },
                    ),
                  ),
                ],
              ),
            ),
            verticalSpaceMedium,
          ],
        ),
      ),
    );
  }

  Widget _buildImageOption({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: EdgeInsets.all(16.w),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: Theme.of(context).primaryColor.withValues(alpha: 0.2),
          ),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 28.w,
              color: Theme.of(context).primaryColor,
            ),
            verticalSpaceSmall,
            Text(
              label,
              style: TextStyle(
                fontSize: 12.sp,
                fontWeight: FontWeight.w600,
                color: Theme.of(context).primaryColor,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  void _showCountryPicker() {
    showCountryPicker(
      context: context,
      favorite: ['in', 'ae', 'us', 'gb', 'ca', 'au'],
      showPhoneCode: true,
      showSearch: true,
      searchAutofocus: true,
      moveAlongWithKeyboard: true,
      countryListTheme: CountryListThemeData(
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(24),
          topRight: Radius.circular(24),
        ),
        searchTextStyle: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search Country',
          hintText: 'Type country name or code',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
        ),
        flagSize: 25,
        backgroundColor: Theme.of(context).colorScheme.surface,
        textStyle: TextStyle(
          fontSize: 16.sp,
          color: Theme.of(context).colorScheme.onSurface,
        ),
        bottomSheetHeight: 500.h,
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
          _phoneController.text = "+${country.phoneCode}";
        });
      },
    );
  }

  void _showLocationPicker() async {
    final result = await Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => LocationPicker(
          initialLocation: _selectedLocation,
          title: 'Select Dealership Location',
          onLocationSelected: (latLng, address) {
            debugPrint('=== LOCATION PICKER CALLBACK ===');
            debugPrint(
                'Location selected: ${latLng.latitude}, ${latLng.longitude}');
            debugPrint('Address from picker: "$address"');
            debugPrint('Address length: ${address.length}');
            debugPrint('Address is empty: ${address.isEmpty}');
            debugPrint('Address contains comma: ${address.contains(',')}');
            debugPrint('================================');

            setState(() {
              _selectedLocation = latLng;
              _locationAddress = address;
              _locationEditController.text = address;
              debugPrint(
                  'Updated state - Location: $_selectedLocation, Address: $_locationAddress');
            });

            // If the address is empty or looks like coordinates, try to get a better address
            if (address.isEmpty || address.contains(',')) {
              debugPrint('Getting better address from coordinates...');
              _getPlaceNameFromCoordinates(latLng).then((betterAddress) {
                debugPrint('Better address received: $betterAddress');
                if (mounted) {
                  setState(() {
                    _locationAddress = betterAddress;
                    _locationEditController.text = betterAddress;
                    debugPrint(
                        'Updated state with better address: $_locationAddress');
                  });
                }
              });
            }
          },
        ),
      ),
    );
  }

  // Convert coordinates to place name using reverse geocoding
  Future<String> _getPlaceNameFromCoordinates(LatLng coordinates) async {
    debugPrint(
        'Starting geocoding for coordinates: ${coordinates.latitude}, ${coordinates.longitude}');
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        coordinates.latitude,
        coordinates.longitude,
      );

      debugPrint('Found ${placemarks.length} placemarks');

      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        debugPrint('Placemark: $placemark');

        // Build a short address with just location and state
        final addressParts = <String>[];

        // if (placemark.name != null && placemark.locality!.isNotEmpty) {
        addressParts.add(placemark.subLocality!);
        // }
        if (placemark.administrativeArea != null &&
            placemark.administrativeArea!.isNotEmpty) {
          addressParts.add(placemark.subAdministrativeArea!);
        }

        final address = addressParts.join(', ');
        debugPrint('Built address: $address');

        if (address.isNotEmpty) {
          return address;
        }
      }
    } catch (e) {
      debugPrint('Error getting place name from coordinates: $e');
    }

    // Fallback: return coordinates as string
    final fallbackAddress =
        '${coordinates.latitude.toStringAsFixed(6)}, ${coordinates.longitude.toStringAsFixed(6)}';
    debugPrint('Using fallback address: $fallbackAddress');
    return fallbackAddress;
  }

  void _refreshSellerDetails(UserProvider userProvider) {
    // Get the current Firebase UID
    final currentUid = userProvider.firebaseUser?.uid;

    if (currentUid == null) {
      debugPrint('Cannot refresh seller details: Firebase UID is null');
      return;
    }

    debugPrint('Current Firebase UID: $currentUid');

    // Wait a bit for the backend to process the update
    Future.delayed(const Duration(milliseconds: 1500), () {
      if (mounted) {
        try {
          debugPrint('Refreshing seller details for UID: $currentUid');

          // Call the seller details method with the current UID
          userProvider.eitherFailureOrSeller(
            value: currentUid,
          );

          // Also try to get all sellers to ensure data is fresh
          userProvider.eitherFailureOrAllSellers();
        } catch (e) {
          debugPrint('Error refreshing seller details: $e');
        }
      } else {
        debugPrint('Cannot refresh seller details: widget not mounted');
      }
    });
  }

  Future<void> _handleSubmit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    // Validate location separately since it's not a form field
    final locationError = _validateLocation();
    if (locationError != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(locationError),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);

      // Get the current Firebase UID
      final currentUid = userProvider.firebaseUser?.uid;

      // Check if user is available
      if (currentUid == null) {
        throw Exception('User not authenticated - Firebase UID is null');
      }

      debugPrint("Current Firebase UID: $currentUid");

      // Upload image if selected
      String imageUrl = '';
      if (userProvider.hasImage && userProvider.image != null) {
        imageUrl = await userProvider.uploadImage(userProvider.image!);
      } else {
        imageUrl = userProvider.firebaseUser?.photoURL ?? '';
      }

      // Get place name from coordinates if available
      String finalLocation = _locationAddress ?? '';
      if (_selectedLocation != null && finalLocation.isEmpty) {
        finalLocation = await _getPlaceNameFromCoordinates(_selectedLocation!);
      }

      // Create seller model
      final seller = SellerModel(
        id: '', // Empty ID for new seller creation
        uid: currentUid,
        displayName: _nameController.text.trim(),
        email: _emailController.text.trim(),
        dealershipName: _nameController.text.trim(),
        contactNumber: _phoneController.text.trim(),
        location: finalLocation,
        photoURL: imageUrl,
        latitude: _selectedLocation?.latitude,
        longitude: _selectedLocation?.longitude,
      );

      debugPrint("Created seller model: ${seller.toJson()}");
      debugPrint("User UID: $currentUid");
      debugPrint("Location selected: ${_selectedLocation != null}");
      debugPrint("Location address: $_locationAddress");

      // Update seller
      final response = await userProvider.eitherFailureOrUpdateSeller(
        params: AddSellerParams(data: seller),
      );

      response.fold(
        (failure) {
          if (mounted) {
            debugPrint("Seller creation failed: ${failure.errorMessage}");
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content:
                    Text('Failed to create seller profile. Please try again.'),
                backgroundColor: Colors.red,
                duration: Duration(seconds: 3),
              ),
            );
          }
        },
        (success) {
          if (mounted) {
            // Show success message
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Profile updated successfully!'),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Pop the current page
            Navigator.pop(context);

            // Get seller details after successful update
            // Use a more reliable approach with proper error handling
            _refreshSellerDetails(userProvider);
          }
        },
      );
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  // Validation methods
  String? _validateName(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your full name';
    }
    if (value.trim().length < 2) {
      return 'Name must be at least 2 characters';
    }
    if (!RegExp(r'^[a-zA-Z\s]+$').hasMatch(value.trim())) {
      return 'Name can only contain letters and spaces';
    }
    return null;
  }

  String? _validatePhone(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your phone number';
    }
    // More flexible phone validation
    final phoneRegex = RegExp(r'^\+?[\d\s\-\(\)]{8,15}$');
    if (!phoneRegex.hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _validateLocation() {
    if (_selectedLocation == null) {
      return 'Please select your location';
    }
    // If we have coordinates but no address, we can still proceed
    // The address will be generated from coordinates during submission
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter your email address';
    }
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$')
        .hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
