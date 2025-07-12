import 'dart:developer';

import 'package:car_app_beta/src/widgets/auth_background.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final bool _emailSent = false;

  @override
  void dispose() {
    _emailController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return AuthBackground(
      child: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24.0),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Icon(
                    _emailSent
                        ? FontAwesomeIcons.envelopeCircleCheck
                        : FontAwesomeIcons.lockOpen,
                    size: 64,
                    color: theme.primaryColor,
                  ),
                  const SizedBox(height: 24),
                  Text(
                    _emailSent ? 'Email Sent!' : 'Forgot Password?',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    _emailSent
                        ? 'Please check your email for password reset instructions'
                        : 'Enter your email and we will send you instructions to reset your password',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 32),
                  if (!_emailSent) ...[
                    // Email Field
                    TextFormField(
                      controller: _emailController,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(
                          FontAwesomeIcons.envelope,
                          size: 20,
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(16),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        // Add email validation
                        return null;
                      },
                    ),
                    const SizedBox(height: 24),
                    // Send Reset Link Button
                    ElevatedButton.icon(
                      onPressed: () async {
                        if (_formKey.currentState!.validate()) {
                          EasyLoading.show();
                        }

                        try {
                          await FirebaseAuth.instance.sendPasswordResetEmail(
                              email: _emailController.text);
                          EasyLoading.dismiss();

                          StyledDialog.show(
                            context: context,
                            message: 'Password reset email sent successfully',
                          );
                        } on FirebaseAuthException catch (e) {
                          // Specific handling for FirebaseAuthException
                          debugPrint("Firebase Auth error: ${e.message}");
                          rethrow; // rethrow if you want the error to propagate
                        } catch (e) {
                          // Generic error catch
                          debugPrint("General error: $e");
                          rethrow;
                        }
                      },
                      icon: const Icon(FontAwesomeIcons.paperPlane, size: 20),
                      label: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Send Reset Link',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                  if (_emailSent) ...[
                    ElevatedButton.icon(
                      onPressed: () => Navigator.pop(context),
                      icon: const Icon(FontAwesomeIcons.arrowLeft, size: 20),
                      label: const Padding(
                        padding: EdgeInsets.all(16.0),
                        child: Text(
                          'Back to Login',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: theme.primaryColor,
                        foregroundColor: Colors.white,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        elevation: 2,
                      ),
                    ),
                  ],
                  const SizedBox(height: 24),
                  // Back to Login Link
                  if (!_emailSent)
                    Center(
                      child: TextButton(
                        onPressed: () => Navigator.pop(context),
                        style: TextButton.styleFrom(
                          foregroundColor: Colors.grey[600],
                        ),
                        child: const Text('Back to Login'),
                      ),
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
