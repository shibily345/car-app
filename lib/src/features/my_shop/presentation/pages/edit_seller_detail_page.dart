import 'dart:io';

import 'package:car_app_beta/core/constants/constants.dart';
import 'package:car_app_beta/core/core_widgets.dart';
import 'package:car_app_beta/core/params/params.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/features/auth/data/models/seller.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
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
  Country code = Country.parse("us");
  TextEditingController numController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController locationController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();

    numController =
        TextEditingController(text: widget.sellerData.contactNumber);
    nameController =
        TextEditingController(text: widget.sellerData.dealershipName);
    emailController = TextEditingController(text: widget.sellerData.email);
    locationController =
        TextEditingController(text: widget.sellerData.location);
  }

  @override
  void dispose() {
    numController.dispose();
    nameController.dispose();
    locationController.dispose();
    emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer2<AuthenticationProvider, UserProvider>(
      builder: (context, ap, up, state) {
        // SellerModel data = SellerModel(
        //   uid: widget.sellerData.uid,
        //   displayName: widget.sellerData.displayName,
        //   email: emailController.text,
        //   dealershipName: nameController.text,
        //   contactNumber: numController.text,
        //   location: locationController.text,
        //   photoURL: up.hasImage ? up.imageName : widget.sellerData.photoURL,
        // );

        var th = Theme.of(context);
        var sz = MediaQuery.of(context).size;

        return Scaffold(
          appBar: AppBar(
            title: const TextDef("Your Details"),
          ),
          body: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30),
            child: Form(
              key: _formKey,
              child: ListView(
                children: [
                  const SizedBox(height: 20),
                  Center(
                    child: Container(
                      margin: const EdgeInsets.symmetric(vertical: 20),
                      decoration: BoxDecoration(
                        image: _buildUserImage(up, widget.sellerData.photoURL),
                        color: th.splashColor,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      height: 130,
                      width: 130,
                      child: Center(
                        child: IconButton(
                          onPressed: up.pickImage,
                          icon: Icon(
                            up.hasImage ? null : Icons.camera_alt_outlined,
                            size: 40,
                          ),
                        ),
                      ),
                    ),
                  ),
                  CustomTextField(
                    controller: nameController,
                    prefixIcon: Icons.person,
                    labelText: "Edit Name",
                  ),
                  const SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: () => _showPicker(context),
                        child: TextDef(
                          code.flagEmoji,
                          fontSize: 40,
                        ),
                      ),
                      Expanded(
                        child: CustomTextField(
                          controller: numController,
                          labelText: "Whatsapp Number with Code",
                          validator: _phoneValidator,
                        ),
                      ),
                    ],
                  ),
                  CustomTextField(
                    controller: locationController,
                    labelText: "Edit Location",
                  ),
                  CustomTextField(
                    controller: emailController,
                    labelText: "Edit Email",
                    validator: _emailValidator,
                  ),
                  const SizedBox(height: 40),
                  OutlineButton(
                    label: "Confirm",
                    icon: Icons.done_outline_rounded,
                    onPressed: () async {
                      if (_formKey.currentState!.validate()) {
                        String iName = "";
                        if (up.hasImage) {
                          iName = await up.uploadImage(up.image);
                        }
                        // Proceed with saving seller details
                        SellerModel data = SellerModel(
                          id: widget.sellerData.id,
                          uid: widget.sellerData.uid,
                          displayName: widget.sellerData.displayName,
                          email: emailController.text,
                          dealershipName: nameController.text,
                          contactNumber: numController.text,
                          location: locationController.text,
                          photoURL:
                              up.hasImage ? iName : widget.sellerData.photoURL,
                        );
                        up.eitherFailureOrEditSeller(
                            params: AddSellerParams(data: data));
                        Navigator.pushNamed(context, "/");
                      }
                    },
                  ),
                  const SizedBox(height: 200),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  DecorationImage? _buildUserImage(UserProvider up, String dp) {
    if (up.hasImage && File(up.image.path).existsSync()) {
      return DecorationImage(
          image: FileImage(File(up.image.path)), fit: BoxFit.cover);
    } else {
      String url = dp; // Example URL

      String finalUrl;

      if (url.startsWith('ww')) {
        finalUrl = url;
      } else {
        finalUrl = '${Ac.baseUrl}$url';
      }
      return DecorationImage(image: NetworkImage(finalUrl), fit: BoxFit.cover);
    }
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

  void _showPicker(BuildContext context) {
    showCountryPicker(
      context: context,
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
          labelText: 'Search',
          hintText: 'Start typing to search',
          prefixIcon: const Icon(Icons.search),
          border: OutlineInputBorder(
            borderSide: BorderSide(
              color: const Color(0xFF8C98A8).withOpacity(0.2),
            ),
          ),
        ),
      ),
      onSelect: (Country country) {
        setState(() {
          code = country;
          numController.text = "+${code.phoneCode}";
        });
      },
    );
  }
}
