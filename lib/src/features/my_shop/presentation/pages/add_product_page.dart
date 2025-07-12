import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/widgets/widgets.dart';
import 'package:car_app_beta/src/widgets/common/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final PageController _pageController = PageController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarCreateProvider>().clearAll();
    });
  }

  void _nextPage() {
    _pageController.nextPage(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeInOut,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      floatingActionButton: FloatingActionButton(
        onPressed: _nextPage,
        child: const Icon(Icons.arrow_forward),
      ),
      body: SafeArea(
        child: Consumer<CarCreateProvider>(
          builder: (context, cp, _) {
            return PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                CarDetailForm(
                  cp: cp,
                  pageController: _pageController,
                ),
                const FeturesForm(),
                const ImageUploadForm(),
                const LocationForm(),
                ConfirmationForm(car: cp.carData!),
              ],
            );
          },
        ),
      ),
    );
  }
}
