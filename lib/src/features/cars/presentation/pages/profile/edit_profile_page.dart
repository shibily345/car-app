import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/custom_button.dart';
import 'package:car_app_beta/src/widgets/inputs/styled_inputs.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _bioController = TextEditingController();

  bool _isLoading = false;
  String? _selectedImagePath;

  @override
  void initState() {
    super.initState();
    _loadUserData();
  }

  void _loadUserData() {
    final userProvider = context.read<UserProvider>();
    if (userProvider.firebaseUser != null) {
      _nameController.text = userProvider.firebaseUser!.displayName ?? '';
      _emailController.text = userProvider.firebaseUser!.email ?? '';
      _phoneController.text = userProvider.firebaseUser!.phoneNumber ?? '';
      _bioController.text = ''; // Add bio field to user model if needed
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _bioController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);

    return Scaffold(
      backgroundColor: th.colorScheme.surface,
      appBar: AppBar(
        title: const Text('Edit Profile'),
        backgroundColor: th.colorScheme.primary,
        foregroundColor: th.colorScheme.onPrimary,
        actions: [
          TextButton(
            onPressed: _isLoading ? null : _saveProfile,
            child: TextDef(
              'Save',
              color: th.colorScheme.onPrimary,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
      body: Consumer<UserProvider>(
        builder: (context, userProvider, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Profile Picture Section
                  _buildProfilePictureSection(context, userProvider),
                  const SizedBox(height: 32),

                  // Personal Information Section
                  _buildSectionHeader(context, 'Personal Information'),
                  const SizedBox(height: 16),

                  // Name Field
                  _buildInputField(
                    context,
                    controller: _nameController,
                    label: 'Full Name',
                    icon: FontAwesomeIcons.user,
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your name';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Email Field
                  _buildInputField(
                    context,
                    controller: _emailController,
                    label: 'Email',
                    icon: FontAwesomeIcons.envelope,
                    enabled: false, // Email should not be editable
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return 'Please enter your email';
                      }
                      if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$')
                          .hasMatch(value)) {
                        return 'Please enter a valid email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Phone Field
                  _buildInputField(
                    context,
                    controller: _phoneController,
                    label: 'Phone Number',
                    icon: FontAwesomeIcons.phone,
                    keyboardType: TextInputType.phone,
                    validator: (value) {
                      if (value != null && value.trim().isNotEmpty) {
                        if (!RegExp(r'^\+?[\d\s-]+$').hasMatch(value)) {
                          return 'Please enter a valid phone number';
                        }
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),

                  // Bio Field
                  _buildInputField(
                    context,
                    controller: _bioController,
                    label: 'Bio (Optional)',
                    icon: FontAwesomeIcons.infoCircle,
                    maxLines: 3,
                    validator: null,
                  ),
                  const SizedBox(height: 32),

                  // Preferences Section
                  _buildSectionHeader(context, 'Preferences'),
                  const SizedBox(height: 16),

                  // Notification Preferences
                  _buildSwitchTile(
                    context,
                    icon: FontAwesomeIcons.bell,
                    title: 'Push Notifications',
                    subtitle:
                        'Receive notifications about new cars and updates',
                    value: true,
                    onChanged: (value) {
                      // Handle notification preference
                    },
                  ),

                  _buildSwitchTile(
                    context,
                    icon: FontAwesomeIcons.envelope,
                    title: 'Email Notifications',
                    subtitle: 'Receive updates via email',
                    value: false,
                    onChanged: (value) {
                      // Handle email preference
                    },
                  ),

                  _buildSwitchTile(
                    context,
                    icon: FontAwesomeIcons.locationDot,
                    title: 'Location Services',
                    subtitle: 'Allow app to access your location',
                    value: true,
                    onChanged: (value) {
                      // Handle location preference
                    },
                  ),
                  const SizedBox(height: 32),

                  // Privacy Section
                  _buildSectionHeader(context, 'Privacy'),
                  const SizedBox(height: 16),

                  _buildSwitchTile(
                    context,
                    icon: FontAwesomeIcons.eye,
                    title: 'Public Profile',
                    subtitle: 'Allow others to see your profile',
                    value: false,
                    onChanged: (value) {
                      // Handle privacy preference
                    },
                  ),

                  _buildSwitchTile(
                    context,
                    icon: FontAwesomeIcons.share,
                    title: 'Share Activity',
                    subtitle: 'Share your rental activity with friends',
                    value: true,
                    onChanged: (value) {
                      // Handle sharing preference
                    },
                  ),
                  const SizedBox(height: 32),

                  // Save Button
                  SizedBox(
                    width: double.infinity,
                    child: CustomButton(
                      label: 'Save Changes',
                      onPressed: _isLoading ? null : _saveProfile,
                      child: _isLoading
                          ? const SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : const TextDef(
                              'Save Changes',
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // Cancel Button
                  SizedBox(
                    width: double.infinity,
                    child: OutlinedButton(
                      onPressed:
                          _isLoading ? null : () => Navigator.pop(context),
                      style: OutlinedButton.styleFrom(
                        padding: const EdgeInsets.symmetric(vertical: 16),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      child: const TextDef(
                        'Cancel',
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildProfilePictureSection(
      BuildContext context, UserProvider userProvider) {
    final th = Theme.of(context);

    return Center(
      child: Column(
        children: [
          // Profile Picture
          Stack(
            children: [
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: th.colorScheme.primary.withAlpha(77),
                    width: 4,
                  ),
                ),
                child: ClipOval(
                  child: _selectedImagePath != null
                      ? Image.asset(
                          _selectedImagePath!,
                          fit: BoxFit.cover,
                        )
                      : userProvider.firebaseUser!.photoURL != null
                          ? Image.network(
                              userProvider.firebaseUser!.photoURL!,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return _buildDefaultAvatar(th);
                              },
                            )
                          : _buildDefaultAvatar(th),
                ),
              ),

              // Edit Button
              Positioned(
                bottom: 0,
                right: 0,
                child: Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: th.colorScheme.primary,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 3),
                  ),
                  child: Icon(
                    Icons.camera_alt,
                    size: 20,
                    color: th.colorScheme.onPrimary,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Change Photo Button
          TextButton.icon(
            onPressed: _showImagePickerDialog,
            icon: const Icon(Icons.edit),
            label: const TextDef('Change Photo'),
            style: TextButton.styleFrom(
              foregroundColor: th.colorScheme.primary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDefaultAvatar(ThemeData th) {
    return Container(
      color: th.colorScheme.primary.withAlpha(26),
      child: Icon(
        Icons.person,
        size: 60,
        color: th.colorScheme.primary,
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return TextDef(
      title,
      fontSize: 18,
      fontWeight: FontWeight.bold,
      color: Theme.of(context).colorScheme.primary,
    );
  }

  Widget _buildInputField(
    BuildContext context, {
    required TextEditingController controller,
    required String label,
    required IconData icon,
    bool enabled = true,
    TextInputType? keyboardType,
    int maxLines = 1,
    String? Function(String?)? validator,
  }) {
    final th = Theme.of(context);

    return Container(
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withAlpha(51)),
      ),
      child: TextFormField(
        controller: controller,
        enabled: enabled,
        keyboardType: keyboardType,
        maxLines: maxLines,
        validator: validator,
        style: TextStyle(
          color: enabled
              ? th.colorScheme.onSurface
              : th.colorScheme.onSurface.withAlpha(153),
        ),
        decoration: InputDecoration(
          labelText: label,
          prefixIcon: Icon(icon, color: th.colorScheme.primary),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
          labelStyle: TextStyle(
            color: th.colorScheme.onSurface.withOpacity(0.7),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    final th = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: th.colorScheme.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(icon, size: 20, color: th.colorScheme.primary),
        ),
        title: TextDef(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitle: TextDef(
          subtitle,
          fontSize: 12,
          color: th.colorScheme.onSurface.withOpacity(0.7),
        ),
        trailing: Switch(
          value: value,
          onChanged: onChanged,
          activeColor: th.colorScheme.primary,
        ),
      ),
    );
  }

  void _showImagePickerDialog() {
    showModalBottomSheet(
      context: context,
      builder: (context) => Container(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.camera_alt),
              title: const Text('Take Photo'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.camera);
              },
            ),
            ListTile(
              leading: const Icon(Icons.photo_library),
              title: const Text('Choose from Gallery'),
              onTap: () {
                Navigator.pop(context);
                _pickImage(ImageSource.gallery);
              },
            ),
            ListTile(
              leading: const Icon(Icons.delete),
              title: const Text('Remove Photo'),
              onTap: () {
                Navigator.pop(context);
                setState(() {
                  _selectedImagePath = null;
                });
              },
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _pickImage(ImageSource source) async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: source,
        maxWidth: 512,
        maxHeight: 512,
        imageQuality: 80,
      );

      if (image != null) {
        setState(() {
          _selectedImagePath = image.path;
        });
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error picking image: $e')),
      );
    }
  }

  Future<void> _saveProfile() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      // Simulate API call
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically update the user profile
      // await userProvider.updateProfile(...);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Profile updated successfully!'),
            backgroundColor: Colors.green,
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
}
