import 'dart:io';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/cached_image.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class EditSellerDetailPage extends StatefulWidget {
  const EditSellerDetailPage({super.key, required this.sellerData});
  final SellerModel sellerData;

  @override
  State<EditSellerDetailPage> createState() => _EditSellerDetailPageState();
}

class _EditSellerDetailPageState extends State<EditSellerDetailPage> {
  Country _selectedCountry = Country.parse("in"); // Default to India
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _initializeControllers();
  }

  void _initializeControllers() {
    _phoneController.text =
        widget.sellerData.contactNumber.replaceAll(RegExp(r'^\+\d+'), '');
    _nameController.text = widget.sellerData.dealershipName;
    _emailController.text = widget.sellerData.email;
    _locationController.text = widget.sellerData.location;

    // Set country based on phone number
    final phoneNumber = widget.sellerData.contactNumber;
    if (phoneNumber.startsWith('+91')) {
      _selectedCountry = Country.parse("in");
    } else if (phoneNumber.startsWith('+971')) {
      _selectedCountry = Country.parse("ae");
    } else if (phoneNumber.startsWith('+1')) {
      _selectedCountry = Country.parse("us");
    } else {
      _selectedCountry = Country.parse("in"); // Default to India
    }
  }

  @override
  void dispose() {
    _phoneController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final screenSize = MediaQuery.of(context).size;

    return Consumer2<AuthenticationProvider, UserProvider>(
      builder: (context, authProvider, userProvider, _) {
        return Scaffold(
          backgroundColor: theme.colorScheme.surface,
          appBar: _buildAppBar(theme),
          body: Container(
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: [
                  theme.primaryColor.withAlpha(13),
                  theme.colorScheme.surface,
                ],
              ),
            ),
            child: SafeArea(
              child: Form(
                key: _formKey,
                child: ListView(
                  padding: EdgeInsets.all(screenSize.width * 0.05),
                  children: [
                    _buildProfileImageSection(userProvider, theme, screenSize),
                    SizedBox(height: screenSize.height * 0.03),
                    _buildFormFields(userProvider, theme, screenSize),
                    SizedBox(height: screenSize.height * 0.04),
                    _buildSaveButton(userProvider, theme, screenSize),
                    SizedBox(height: screenSize.height * 0.1),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(ThemeData theme) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: IconButton(
        onPressed: () => Navigator.pop(context),
        icon: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: theme.primaryColor.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(
            Icons.arrow_back_ios_new,
            color: theme.primaryColor,
            size: 20,
          ),
        ),
      ),
      title: Text(
        'Edit Profile',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20,
        ),
      ),
      centerTitle: true,
    );
  }

  Widget _buildProfileImageSection(
    UserProvider userProvider,
    ThemeData theme,
    Size screenSize,
  ) {
    return Center(
      child: Column(
        children: [
          Container(
            width: screenSize.width * 0.3,
            height: screenSize.width * 0.3,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: theme.primaryColor.withAlpha(51),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: Stack(
                children: [
                  _buildProfileImage(userProvider, theme),
                  Positioned(
                    bottom: 0,
                    right: 0,
                    child: GestureDetector(
                      onTap: userProvider.pickImage,
                      child: Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: theme.primaryColor,
                          shape: BoxShape.circle,
                          boxShadow: [
                            BoxShadow(
                              color: theme.primaryColor.withAlpha(51),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.camera_alt,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: screenSize.height * 0.02),
          Text(
            'Tap to change photo',
            style: theme.textTheme.bodySmall?.copyWith(
              color: Colors.grey.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileImage(UserProvider userProvider, ThemeData theme) {
    if (userProvider.hasImage && userProvider.image != null) {
      return Image.file(
        File(userProvider.image!.path),
        fit: BoxFit.cover,
        width: double.infinity,
        height: double.infinity,
      );
    } else {
      final imageUrl = _getImageUrl(widget.sellerData.photoURL);
      return CachedImageWithShimmer(
        imageUrl: imageUrl,
        width: double.infinity,
        height: double.infinity,
      );
    }
  }

  Widget _buildFormFields(
    UserProvider userProvider,
    ThemeData theme,
    Size screenSize,
  ) {
    return Column(
      children: [
        _buildModernTextField(
          controller: _nameController,
          label: 'Dealership Name',
          icon: Icons.business,
          theme: theme,
          validator: _nameValidator,
        ),
        SizedBox(height: screenSize.height * 0.02),
        _buildPhoneField(theme, screenSize),
        SizedBox(height: screenSize.height * 0.02),
        _buildModernTextField(
          controller: _locationController,
          label: 'Location',
          icon: Icons.location_on,
          theme: theme,
          validator: _locationValidator,
        ),
        SizedBox(height: screenSize.height * 0.02),
        _buildModernTextField(
          controller: _emailController,
          label: 'Email Address',
          icon: Icons.email,
          theme: theme,
          validator: _emailValidator,
          keyboardType: TextInputType.emailAddress,
        ),
      ],
    );
  }

  Widget _buildModernTextField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
    required ThemeData theme,
    required String? Function(String?) validator,
    TextInputType? keyboardType,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withAlpha(26),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        keyboardType: keyboardType ?? TextInputType.text,
        validator: validator,
        style: TextStyle(
          fontSize: 16,
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.w500,
        ),
        decoration: InputDecoration(
          labelText: label,
          labelStyle: TextStyle(
            color: theme.primaryColor,
            fontWeight: FontWeight.w600,
            fontSize: 14,
          ),
          prefixIcon: Container(
            margin: const EdgeInsets.all(12),
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: theme.primaryColor.withAlpha(26),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: theme.primaryColor,
              size: 20,
            ),
          ),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
          floatingLabelBehavior: FloatingLabelBehavior.auto,
        ),
      ),
    );
  }

  Widget _buildPhoneField(ThemeData theme, Size screenSize) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: theme.primaryColor.withAlpha(26),
          width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withAlpha(26),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => _showCountryPicker(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              decoration: BoxDecoration(
                color: theme.primaryColor.withAlpha(26),
                borderRadius: const BorderRadius.only(
                  topLeft: Radius.circular(16),
                  bottomLeft: Radius.circular(16),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    _selectedCountry.flagEmoji,
                    style: const TextStyle(fontSize: 20),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '+${_selectedCountry.phoneCode}',
                    style: TextStyle(
                      color: theme.primaryColor,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Icon(
                    Icons.keyboard_arrow_down,
                    color: theme.primaryColor,
                    size: 18,
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: TextFormField(
              controller: _phoneController,
              keyboardType: TextInputType.phone,
              validator: _phoneValidator,
              style: TextStyle(
                fontSize: 16,
                color: theme.colorScheme.onSurface,
                fontWeight: FontWeight.w500,
              ),
              decoration: InputDecoration(
                labelText: 'Phone Number',
                labelStyle: TextStyle(
                  color: theme.primaryColor,
                  fontWeight: FontWeight.w600,
                  fontSize: 14,
                ),
                border: InputBorder.none,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 16,
                ),
                floatingLabelBehavior: FloatingLabelBehavior.auto,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSaveButton(
    UserProvider userProvider,
    ThemeData theme,
    Size screenSize,
  ) {
    return Container(
      width: double.infinity,
      height: 56,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        gradient: LinearGradient(
          colors: [
            theme.primaryColor,
            theme.primaryColor.withAlpha(204),
          ],
        ),
        boxShadow: [
          BoxShadow(
            color: theme.primaryColor.withAlpha(51),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: _isLoading ? null : () => _saveProfile(userProvider),
          child: Center(
            child: _isLoading
                ? SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(
                        Colors.white.withAlpha(204),
                      ),
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.save,
                        color: Colors.white,
                        size: 20,
                      ),
                      SizedBox(width: 8),
                      Text(
                        'Save Changes',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveProfile(UserProvider userProvider) async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isLoading = true);

    try {
      String imageName = "";
      if (userProvider.hasImage && userProvider.image != null) {
        imageName = await userProvider.uploadImage(userProvider.image!);
      }

      final updatedSeller = SellerModel(
        id: widget.sellerData.id,
        uid: widget.sellerData.uid,
        displayName: widget.sellerData.displayName,
        email: _emailController.text.trim(),
        dealershipName: _nameController.text.trim(),
        contactNumber:
            '+${_selectedCountry.phoneCode}${_phoneController.text.trim()}',
        location: _locationController.text.trim(),
        photoURL:
            userProvider.hasImage ? imageName : widget.sellerData.photoURL,
      );

      await userProvider.eitherFailureOrEditSeller(
        params: AddSellerParams(data: updatedSeller),
      );

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: const Text('Profile updated successfully!'),
            backgroundColor: Theme.of(context).primaryColor,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
        Navigator.pop(context);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error updating profile: $e'),
            backgroundColor: Colors.red,
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        );
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  String _getImageUrl(String url) {
    return url.startsWith('ww') ? url : '${Ac.baseUrl}$url';
  }

  String? _nameValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter dealership name';
    }
    if (value.trim().length < 2) {
      return 'Dealership name must be at least 2 characters';
    }
    return null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter phone number';
    }
    if (!RegExp(r'^\d{7,15}$').hasMatch(value.trim())) {
      return 'Please enter a valid phone number';
    }
    return null;
  }

  String? _locationValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter location';
    }
    if (value.trim().length < 3) {
      return 'Location must be at least 3 characters';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Please enter email address';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value.trim())) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      context: context,
      favorite: [
        'in',
        'ae',
        'us',
        'gb',
        'ca'
      ], // India, UAE, US, UK, Canada as favorites
      countryListTheme: CountryListThemeData(
        flagSize: 25,
        backgroundColor: Colors.white,
        textStyle: const TextStyle(fontSize: 16, color: Colors.blueGrey),
        bottomSheetHeight: 500,
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(20.0),
          topRight: Radius.circular(20.0),
        ),
        inputDecoration: InputDecoration(
          labelText: 'Search Country',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withAlpha(51),
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
        searchTextStyle: const TextStyle(
          fontSize: 16,
          color: Colors.blueGrey,
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          _selectedCountry = country;
        });
      },
    );
  }
}
