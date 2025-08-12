import 'package:car_app_beta/src/features/my_shop/presentation/providers/update_provider.dart';
import 'package:car_app_beta/src/features/my_shop/presentation/widgets/car_add_forms.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AddNewProductPage extends StatefulWidget {
  const AddNewProductPage({super.key});

  @override
  State<AddNewProductPage> createState() => _AddNewProductPageState();
}

class _AddNewProductPageState extends State<AddNewProductPage> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  final int _totalPages = 5;

  final List<String> _pageTitles = [
    'Car Details',
    'Features',
    'Images',
    'Location & Price',
    'Review & Submit'
  ];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CarCreateProvider>().clearAll();
    });
  }

  void _nextPage() {
    if (_currentPage < _totalPages - 1) {
      setState(() {
        _currentPage++;
      });
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  void _previousPage() {
    if (_currentPage > 0) {
      setState(() {
        _currentPage--;
      });
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(_pageTitles[_currentPage]),
        elevation: 0,
        backgroundColor: theme.primaryColor,
        foregroundColor: Colors.white,
        actions: [
          if (_currentPage < _totalPages - 1)
            TextButton(
              onPressed: _nextPage,
              child: const Text(
                'Skip',
                style: TextStyle(color: Colors.white),
              ),
            ),
        ],
      ),
      body: Column(
        children: [
          // Progress Indicator
          Container(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: List.generate(_totalPages, (index) {
                    return Expanded(
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        height: 4,
                        decoration: BoxDecoration(
                          color: index <= _currentPage
                              ? theme.primaryColor
                              : Colors.grey.shade300,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    );
                  }),
                ),
                const SizedBox(height: 8),
                Text(
                  'Step ${_currentPage + 1} of $_totalPages',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),

          // Page Content
          Expanded(
            child: Consumer<CarCreateProvider>(
              builder: (context, carProvider, _) {
                return PageView(
                  controller: _pageController,
                  physics: const NeverScrollableScrollPhysics(),
                  onPageChanged: (page) {
                    setState(() {
                      _currentPage = page;
                    });
                  },
                  children: [
                    CarDetailsForm(
                      onNext: _nextPage,
                      carProvider: carProvider,
                    ),
                    FeaturesForm(
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                      carProvider: carProvider,
                    ),
                    ImagesForm(
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                      carProvider: carProvider,
                    ),
                    LocationPriceForm(
                      onNext: _nextPage,
                      onPrevious: _previousPage,
                      carProvider: carProvider,
                    ),
                    ReviewForm(
                      onPrevious: _previousPage,
                      carProvider: carProvider,
                    ),
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
