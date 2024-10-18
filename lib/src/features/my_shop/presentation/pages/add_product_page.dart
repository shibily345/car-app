import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/widgets/widgets.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final PageController _pageController = PageController();
  int currentPage = 0;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarCreateProvider>().clearAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<CarCreateProvider>(builder: (context, cp, _) {
      return Scaffold(
        appBar: AppBar(),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _pageController.nextPage(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
            );
          },
          child: const Icon(Icons.arrow_forward),
        ),
        body: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: PageView(
                  //    physics: ScrollPhysics(parent: NeverScrollableScrollPhysics()),
                  controller: _pageController,
                  children: [
                    CarDetailForm(cp: cp),
                    const FeturesForm(),
                    const ImageUploadForm(),
                    const LocationForm(),
                    ConfirmationForm(
                      car: context.watch<CarCreateProvider>().carData!,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      );
    });
  }
}
