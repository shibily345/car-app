import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/animated_press_button.dart';
import 'package:car_app_beta/src/widgets/buttons/glass_button.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  bool _isLoading = false;

  Future<void> _login() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _isLoading = true;
    });

    try {
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Login successful!')),
      );
      // Navigate to the next page
    } on FirebaseAuthException catch (e) {
      String errorMessage;
      switch (e.code) {
        case 'user-not-found':
          errorMessage = 'No user found for that email.';
          break;
        case 'wrong-password':
          errorMessage = 'Wrong password provided.';
          break;
        default:
          errorMessage = 'An error occurred. Please try again.';
      }
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(errorMessage)),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      body: Center(
        child: Consumer2<AuthenticationProvider, UserProvider>(
            builder: (context, ap, up, _) {
          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Form(
              key: _formKey,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  verticalSpaceMassive,
                  Text(
                    'Welcome Back',
                    style: theme.textTheme.headlineMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Sign in to continue',
                    style: theme.textTheme.bodyLarge?.copyWith(
                      color: Colors.grey[600],
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 48),
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
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your email';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  // Password Field
                  TextFormField(
                    controller: _passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      prefixIcon: const Icon(FontAwesomeIcons.lock, size: 20),
                      filled: true,
                      fillColor: Colors.white,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: BorderSide.none,
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter your password';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 8),
                  // Forgot Password Link
                  Align(
                    alignment: Alignment.centerRight,
                    child: TextButton(
                        onPressed: () {},
                        style: TextButton.styleFrom(
                          foregroundColor: theme.primaryColor,
                          padding: EdgeInsets.zero,
                          minimumSize: const Size(0, 0),
                          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                        ),
                        child: const Text('Forgot Password?')),
                  ),

                  const SizedBox(height: 24),
                  // Login Button
                  AnimatedPressButton(
                    label: 'Log In',
                    onPressed: () async {
                      try {
                        final result = await ap.eitherFailureOrAuthWithEmail(
                          _emailController.text.trim(),
                          _passwordController.text.trim(),
                        );

                        if (!mounted) return;

                        if (result.isRight()) {
                          EasyLoading.dismiss();

                          ToastOverlay.show(
                              context: context,
                              message: "Successfully logged in");
                          context.read<CarsProvider>().eitherFailureOrCars();

                          Navigator.pushReplacementNamed(context, '/');
                        } else {
                          EasyLoading.dismiss();
                          StyledDialog.show(
                              context: context,
                              title: "Login Failed",
                              message:
                                  "${result.fold((l) => l, (r) => r)} \n\n\n Try to login with other methods",
                              actions: [
                                DialogAction(
                                  isPrimary: true,
                                  label: 'OK',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                          debugPrint('Login failed');
                        }
                      } catch (error) {
                        EasyLoading.dismiss();
                        StyledDialog.show(
                          context: context,
                          title: "Login Failed",
                          message: "$error",
                        );
                        debugPrint('Error during login: $error');
                      }
                    },
                    width: screenWidth(context) * 0.8,
                    height: 50.h,
                    borderRadius: 50,
                    icon: FontAwesomeIcons.arrowRight,
                  ),
                  const SizedBox(height: 32),
                  // Social Login Section
                  Row(
                    children: [
                      Expanded(child: Divider(color: Colors.grey[400])),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 16),
                        child: Text(
                          'Or Login With',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ),
                      Expanded(child: Divider(color: Colors.grey[400])),
                    ],
                  ),
                  const SizedBox(height: 32),

                  GlassButton(
                    icon: FontAwesomeIcons.google,
                    label: "Login With Google",
                    onPressed: () async {
                      try {
                        final result = await ap.eitherFailureOrAuth();

                        if (!mounted) return;

                        if (result.isRight()) {
                          EasyLoading.dismiss();

                          ToastOverlay.show(
                              context: context,
                              message: "Successfully logged in");
                          context.read<CarsProvider>().eitherFailureOrCars();

                          Navigator.pushReplacementNamed(context, '/');
                        } else {
                          EasyLoading.dismiss();
                          StyledDialog.show(
                              context: context,
                              title: "Login Failed",
                              message: "${result.fold((l) => l, (r) => r)}",
                              actions: [
                                DialogAction(
                                  isPrimary: true,
                                  label: 'OK',
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                )
                              ]);
                          debugPrint('Login failed');
                        }
                      } catch (error) {
                        EasyLoading.dismiss();
                        StyledDialog.show(
                          context: context,
                          title: "Login Failed",
                          message: "$error",
                        );
                        debugPrint('Error during login: $error');
                      }
                    },
                    height: 50.h,
                    width: screenWidth(context) * 0.9,
                  ),
                  verticalSpaceSmall,
                  GlassButton(
                    icon: FontAwesomeIcons.apple,
                    label: "Login With Apple",
                    onPressed: () async {
                      StyledDialog.show(
                        context: context,
                        title: "Coming Soon",
                        message: "This feature is not available yet.",
                      );
                      debugPrint('Apple login button pressed');
                    },
                    height: 50.h,
                    width: screenWidth(context) * 0.9,
                  ),

                  const SizedBox(height: 32),
                  // Register and Skip Section
                  Row(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Text(
                      "Don't have an account?",
                      style: TextStyle(color: Colors.grey[600]),
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pushNamed(context, '/register');
                        },
                        style: TextButton.styleFrom(
                          foregroundColor: theme.primaryColor,
                          padding: const EdgeInsets.symmetric(horizontal: 8),
                        ),
                        child: const Text('Register')),
                  ]), // SpaceY(widget.size.height * 0.04),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}
