import 'dart:io';

import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:country_picker/country_picker.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddSellerDetailPage extends StatefulWidget {
  const AddSellerDetailPage({super.key});
  static const routeName = '/sellerDetails';

  @override
  State<AddSellerDetailPage> createState() => _AddSellerDetailPageState();
}

class _AddSellerDetailPageState extends State<AddSellerDetailPage> {
  final Country _defaultCountry = Country.parse("us");
  final TextEditingController _numController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _locationController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    final authProvider = Provider.of<UserProvider>(context, listen: false);
    _nameController.text = authProvider.firebaseUser?.displayName ?? '';
    _emailController.text = authProvider.firebaseUser?.email ?? '';
  }

  @override
  void dispose() {
    _numController.dispose();
    _nameController.dispose();
    _locationController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Your Details")),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30),
        child: Form(
          key: _formKey,
          child: ListView(
            children: [
              const SizedBox(height: 20),
              _buildProfileImage(context),
              const SizedBox(height: 20),
              _buildTextField(
                controller: _nameController,
                labelText: "Edit Name",
                prefixIcon: Icons.person,
                validator: _requiredValidator("Please enter your name"),
              ),
              const SizedBox(height: 20),
              _buildPhoneField(context),
              _buildTextField(
                controller: _locationController,
                labelText: "Edit Location",
                validator: _requiredValidator("Please enter your location"),
              ),
              verticalSpaceSmall,
              _buildTextField(
                controller: _emailController,
                labelText: "Edit Email",
                validator: _emailValidator,
              ),
              const SizedBox(height: 40),
              ElevatedButton.icon(
                onPressed: _onConfirm,
                icon: const Icon(Icons.done_outline_rounded),
                label: const Text("Confirm"),
              ),
              const SizedBox(height: 200),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildProfileImage(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, _) {
        final image = userProvider.hasImage
            ? FileImage(File(userProvider.image.path))
            : userProvider.firebaseUser?.photoURL != null
                ? NetworkImage(userProvider.firebaseUser!.photoURL!)
                : null;

        return Center(
          child: GestureDetector(
            onTap: userProvider.pickImage,
            child: CircleAvatar(
              radius: 65,
              backgroundImage: image as ImageProvider?,
              child: image == null
                  ? const Icon(Icons.camera_alt_outlined, size: 40)
                  : null,
            ),
          ),
        );
      },
    );
  }

  Widget _buildPhoneField(BuildContext context) {
    return Row(
      children: [
        TextButton(
          onPressed: () => _showCountryPicker(context),
          child: Text(
            _defaultCountry.flagEmoji,
            style: const TextStyle(fontSize: 40),
          ),
        ),
        Expanded(
          child: _buildTextField(
            controller: _numController,
            labelText: "Whatsapp Number with Code",
            validator: _phoneValidator,
          ),
        ),
      ],
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    IconData? prefixIcon,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        prefixIcon: prefixIcon != null ? Icon(prefixIcon) : null,
        border: const OutlineInputBorder(),
      ),
      validator: validator,
    );
  }

  void _showCountryPicker(BuildContext context) {
    showCountryPicker(
      favorite: [
        'in',
        'ae',
      ],
      showPhoneCode: true,

      // Optional. Sheet moves when keyboard opens.
      moveAlongWithKeyboard: false,
      // Optional. Sets the theme for the country list picker.
      countryListTheme: CountryListThemeData(
        // Optional. Sets the border radius for the bottomsheet.
        borderRadius: const BorderRadius.only(
          topLeft: Radius.circular(40.0),
          topRight: Radius.circular(40.0),
        ),
        // Optional. Styles the search field.
        inputDecoration: InputDecoration(
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
        // Optional. Styles the text in the search field
        searchTextStyle: const TextStyle(
          color: Colors.blue,
          fontSize: 18,
        ),
      ),

      context: context,
      onSelect: (Country country) {
        setState(() {
          _numController.text = "+${country.phoneCode}";
        });
      },
    );
  }

  void _onConfirm() async {
    if (_formKey.currentState?.validate() ?? false) {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      final imageUrl = userProvider.hasImage
          ? await userProvider.uploadImage(userProvider.image)
          : userProvider.firebaseUser?.photoURL ?? '';

      final seller = SellerModel(
        id: 'null',
        uid: userProvider.firebaseUser!.uid,
        displayName: _nameController.text,
        email: _emailController.text,
        dealershipName: _nameController.text,
        contactNumber: _numController.text,
        location: _locationController.text,
        photoURL: imageUrl,
      );

      userProvider.eitherFailureOrUpdateSeller(
          params: AddSellerParams(data: seller));
      Navigator.pushNamed(context, "/");
    }
  }

  String? Function(String?) _requiredValidator(String message) {
    return (value) => value == null || value.isEmpty ? message : null;
  }

  String? _phoneValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your phone number';
    } else if (!RegExp(r'^\+\d{1,15}$').hasMatch(value)) {
      return 'Please enter a valid phone number with country code';
    }
    return null;
  }

  String? _emailValidator(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    } else if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }
}
