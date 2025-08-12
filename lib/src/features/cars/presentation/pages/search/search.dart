import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  final ScrollController? scrollController;
  const SearchPage({super.key, this.scrollController});

  @override
  SearchPageState createState() => SearchPageState();
}

class SearchPageState extends State<SearchPage> with TickerProviderStateMixin {
  late AnimationController _searchController;
  late AnimationController _filterController;
  late AnimationController _sortController;

  final TextEditingController _searchTextController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = "";
  bool _isFilterExpanded = false;
  bool _isSortExpanded = false;

  // Filter states
  RangeValues _priceRange = const RangeValues(0, 1000000);
  String? _selectedMake;
  String? _selectedModel;
  int? _selectedYear;
  String? _selectedTransmission;
  String? _selectedFuel;
  String? _selectedCategory;

  // Sort state
  String _sortBy = 'relevance';

  // Available options
  final List<String> _transmissions = ['Automatic', 'Manual', 'CVT'];
  final List<String> _fuelTypes = [
    'Petrol',
    'Diesel',
    'Electric',
    'Hybrid',
    'Plug-in Hybrid'
  ];
  final List<String> _categories = [
    'Sedan',
    'SUV',
    'Hatchback',
    'Coupe',
    'Convertible',
    'Wagon',
    'Pickup'
  ];
  final List<String> _sortOptions = [
    'relevance',
    'price_low_high',
    'price_high_low',
    'year_new_old',
    'year_old_new',
    'mileage_low_high',
    'date_new_old'
  ];

  @override
  void initState() {
    super.initState();
    _searchController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sortController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _searchTextController.addListener(() {
      setState(() {
        _searchQuery = _searchTextController.text;
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _filterController.dispose();
    _sortController.dispose();
    _searchTextController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _toggleFilters() {
    setState(() {
      // Close sort panel if it's open
      if (_isSortExpanded) {
        _isSortExpanded = false;
        _sortController.reverse();
      }
      // Toggle filter panel
      _isFilterExpanded = !_isFilterExpanded;
    });
    if (_isFilterExpanded) {
      _filterController.forward();
    } else {
      _filterController.reverse();
    }
  }

  void _toggleSort() {
    setState(() {
      // Close filter panel if it's open
      if (_isFilterExpanded) {
        _isFilterExpanded = false;
        _filterController.reverse();
      }
      // Toggle sort panel
      _isSortExpanded = !_isSortExpanded;
    });
    if (_isSortExpanded) {
      _sortController.forward();
    } else {
      _sortController.reverse();
    }
  }

  void _clearAllFilters() {
    setState(() {
      _priceRange = const RangeValues(0, 1000000);
      _selectedMake = null;
      _selectedModel = null;
      _selectedYear = null;
      _selectedTransmission = null;
      _selectedFuel = null;
      _selectedCategory = null;
      _sortBy = 'relevance';
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: CustomScrollView(
        controller: widget.scrollController,
        slivers: [
          // Custom App Bar with Search
          _buildSliverAppBar(theme, size),

          // Filter and Sort Controls
          _buildFilterSortControls(theme),

          // Search Results
          _buildSearchResults(theme),
        ],
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, Size size) {
    return SliverAppBar(
      // centerTitle: false,
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      title: Text(
        'Search Cars',
        style: TextStyle(
          color: theme.colorScheme.onSurface,
          fontWeight: FontWeight.bold,
          fontSize: 20.sp,
        ),
      ),
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                theme.colorScheme.primary.withValues(alpha: 0.1),
                theme.colorScheme.surface,
              ],
            ),
          ),
        ),
      ),
      bottom: PreferredSize(
        preferredSize: Size.fromHeight(80.h),
        child: _buildSearchBar(theme),
      ),
    );
  }

  Widget _buildSearchBar(ThemeData theme) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        height: 60.h,
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          borderRadius: BorderRadius.circular(30.r),
          boxShadow: [
            BoxShadow(
              color: theme.colorScheme.primary.withValues(alpha: 0.1),
              blurRadius: 10,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: TextField(
                controller: _searchTextController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search cars by make, model, or features...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    fontSize: 16.sp,
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: theme.colorScheme.primary,
                    size: 24.sp,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 20.w,
                    vertical: 15.h,
                  ),
                ),
                style: TextStyle(
                  fontSize: 16.sp,
                  color: theme.colorScheme.onSurface,
                ),
              ),
            ),
            if (_searchQuery.isNotEmpty)
              IconButton(
                onPressed: () {
                  _searchTextController.clear();
                },
                icon: Icon(
                  Icons.clear,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                ),
              ),
          ],
        ),
      ).animate().fadeIn(duration: 300.ms).slideY(begin: -0.3, end: 0),
    );
  }

  Widget _buildFilterSortControls(ThemeData theme) {
    return SliverToBoxAdapter(
      child: Column(
        children: [
          // Filter and Sort Buttons
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            child: Row(
              children: [
                Expanded(
                  child: _buildFilterButton(theme),
                ),
                SizedBox(width: 10.w),
                Expanded(
                  child: _buildSortButton(theme),
                ),
                SizedBox(width: 10.w),
                _buildClearButton(theme),
              ],
            ),
          ),

          // Filter Panel
          _buildFilterPanel(theme),

          // Sort Panel
          _buildSortPanel(theme),
        ],
      ),
    );
  }

  Widget _buildFilterButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleFilters,
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: _isFilterExpanded
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.filter_list,
                color: _isFilterExpanded
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Filters',
                style: TextStyle(
                  color: _isFilterExpanded
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 100.ms);
  }

  Widget _buildSortButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _toggleSort,
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.w),
          decoration: BoxDecoration(
            color: _isSortExpanded
                ? theme.colorScheme.primary
                : theme.colorScheme.primary.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: theme.colorScheme.primary.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.sort,
                color: _isSortExpanded
                    ? theme.colorScheme.onPrimary
                    : theme.colorScheme.primary,
                size: 20.sp,
              ),
              SizedBox(width: 8.w),
              Text(
                'Sort',
                style: TextStyle(
                  color: _isSortExpanded
                      ? theme.colorScheme.onPrimary
                      : theme.colorScheme.primary,
                  fontWeight: FontWeight.w600,
                  fontSize: 14.sp,
                ),
              ),
            ],
          ),
        ),
      ),
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildClearButton(ThemeData theme) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: _clearAllFilters,
        borderRadius: BorderRadius.circular(25.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          decoration: BoxDecoration(
            color: theme.colorScheme.error.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(25.r),
            border: Border.all(
              color: theme.colorScheme.error.withValues(alpha: 0.3),
            ),
          ),
          child: Icon(
            Icons.clear_all,
            color: theme.colorScheme.error,
            size: 20.sp,
          ),
        ),
      ),
    ).animate().fadeIn(delay: 300.ms);
  }

  Widget _buildFilterPanel(ThemeData theme) {
    return AnimatedBuilder(
      animation: _filterController,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _filterController,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Filters',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 20.h),

                // Price Range
                _buildPriceRangeFilter(theme),
                SizedBox(height: 20.h),

                // Make and Model
                _buildMakeModelFilter(theme),
                SizedBox(height: 20.h),

                // Year Filter
                _buildYearFilter(theme),
                SizedBox(height: 20.h),

                // Transmission and Fuel
                Row(
                  children: [
                    Expanded(child: _buildTransmissionFilter(theme)),
                    SizedBox(width: 10.w),
                    Expanded(child: _buildFuelFilter(theme)),
                  ],
                ),
                SizedBox(height: 20.h),

                // Category Filter
                _buildCategoryFilter(theme),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildPriceRangeFilter(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Price Range',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
        RangeSlider(
          values: _priceRange,
          min: 0,
          max: 1000000,
          divisions: 100,
          activeColor: theme.colorScheme.primary,
          inactiveColor: theme.colorScheme.primary.withValues(alpha: 0.3),
          labels: RangeLabels(
            'AED ${_priceRange.start.round()}',
            'AED ${_priceRange.end.round()}',
          ),
          onChanged: (values) {
            setState(() {
              _priceRange = values;
            });
          },
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'AED ${_priceRange.start.round()}',
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
            Text(
              'AED ${_priceRange.end.round()}',
              style: TextStyle(
                fontSize: 14.sp,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildMakeModelFilter(ThemeData theme) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, child) {
        final makes = carsProvider.cars
                ?.map((car) => car.make)
                .where((make) => make != null && make.isNotEmpty)
                .toSet()
                .toList() ??
            [];

        final models = carsProvider.cars
                ?.where(
                    (car) => _selectedMake == null || car.make == _selectedMake)
                .map((car) => car.model)
                .where((model) => model != null && model.isNotEmpty)
                .toSet()
                .toList() ??
            [];

        return Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedMake,
                decoration: InputDecoration(
                  labelText: 'Make',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Makes'),
                  ),
                  ...makes.map((make) => DropdownMenuItem<String>(
                        value: make,
                        child: Text(make!),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMake = value;
                    _selectedModel = null; // Reset model when make changes
                  });
                },
              ),
            ),
            SizedBox(width: 10.w),
            Expanded(
              child: DropdownButtonFormField<String>(
                value: _selectedModel,
                decoration: InputDecoration(
                  labelText: 'Model',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 14.w,
                    vertical: 12.h,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String>(
                    value: null,
                    child: Text('All Models'),
                  ),
                  ...models.map((model) => DropdownMenuItem<String>(
                        value: model,
                        child: Text(model!),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedModel = value;
                  });
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildYearFilter(ThemeData theme) {
    final currentYear = DateTime.now().year;
    final years = List.generate(30, (index) => currentYear - index);

    return DropdownButtonFormField<int>(
      value: _selectedYear,
      decoration: InputDecoration(
        labelText: 'Year',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      items: [
        const DropdownMenuItem<int>(
          value: null,
          child: Text('All Years'),
        ),
        ...years.map((year) => DropdownMenuItem<int>(
              value: year,
              child: Text(year.toString()),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedYear = value;
        });
      },
    );
  }

  Widget _buildTransmissionFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedTransmission,
      decoration: InputDecoration(
        labelText: 'Transmission',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All'),
        ),
        ..._transmissions.map((transmission) => DropdownMenuItem<String>(
              value: transmission,
              child: Text(transmission),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedTransmission = value;
        });
      },
    );
  }

  Widget _buildFuelFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedFuel,
      decoration: InputDecoration(
        labelText: 'Fuel Type',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All'),
        ),
        ..._fuelTypes.map((fuel) => DropdownMenuItem<String>(
              value: fuel,
              child: Text(fuel),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedFuel = value;
        });
      },
    );
  }

  Widget _buildCategoryFilter(ThemeData theme) {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      decoration: InputDecoration(
        labelText: 'Category',
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.r),
        ),
        contentPadding: EdgeInsets.symmetric(
          horizontal: 16.w,
          vertical: 12.h,
        ),
      ),
      items: [
        const DropdownMenuItem<String>(
          value: null,
          child: Text('All Categories'),
        ),
        ..._categories.map((category) => DropdownMenuItem<String>(
              value: category,
              child: Text(category),
            )),
      ],
      onChanged: (value) {
        setState(() {
          _selectedCategory = value;
        });
      },
    );
  }

  Widget _buildSortPanel(ThemeData theme) {
    return AnimatedBuilder(
      animation: _sortController,
      builder: (context, child) {
        return SizeTransition(
          sizeFactor: _sortController,
          child: Container(
            margin: EdgeInsets.symmetric(horizontal: 20.w, vertical: 10.h),
            padding: EdgeInsets.all(20.w),
            decoration: BoxDecoration(
              color: theme.colorScheme.surface,
              borderRadius: BorderRadius.circular(20.r),
              boxShadow: [
                BoxShadow(
                  color: theme.colorScheme.primary.withValues(alpha: 0.1),
                  blurRadius: 10,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Sort By',
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.bold,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                SizedBox(height: 15.h),
                ..._sortOptions
                    .map((option) => _buildSortOption(theme, option)),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSortOption(ThemeData theme, String option) {
    final isSelected = _sortBy == option;
    final optionText = _getSortOptionText(option);
    final icon = _getSortOptionIcon(option);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _sortBy = option;
          });
        },
        borderRadius: BorderRadius.circular(12.r),
        child: Container(
          padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 16.w),
          margin: EdgeInsets.only(bottom: 8.h),
          decoration: BoxDecoration(
            color: isSelected
                ? theme.colorScheme.primary.withValues(alpha: 0.1)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12.r),
            border: Border.all(
              color: isSelected
                  ? theme.colorScheme.primary
                  : theme.colorScheme.onSurface.withValues(alpha: 0.2),
            ),
          ),
          child: Row(
            children: [
              Icon(
                icon,
                color: isSelected
                    ? theme.colorScheme.primary
                    : theme.colorScheme.onSurface.withValues(alpha: 0.6),
                size: 20.sp,
              ),
              SizedBox(width: 12.w),
              Expanded(
                child: Text(
                  optionText,
                  style: TextStyle(
                    fontSize: 16.sp,
                    fontWeight:
                        isSelected ? FontWeight.w600 : FontWeight.normal,
                    color: isSelected
                        ? theme.colorScheme.primary
                        : theme.colorScheme.onSurface,
                  ),
                ),
              ),
              if (isSelected)
                Icon(
                  Icons.check_circle,
                  color: theme.colorScheme.primary,
                  size: 20.sp,
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _getSortOptionText(String option) {
    switch (option) {
      case 'relevance':
        return 'Relevance';
      case 'price_low_high':
        return 'Price: Low to High';
      case 'price_high_low':
        return 'Price: High to Low';
      case 'year_new_old':
        return 'Year: Newest First';
      case 'year_old_new':
        return 'Year: Oldest First';
      case 'mileage_low_high':
        return 'Mileage: Low to High';
      case 'date_new_old':
        return 'Date: Newest First';
      default:
        return option;
    }
  }

  IconData _getSortOptionIcon(String option) {
    switch (option) {
      case 'relevance':
        return Icons.trending_up;
      case 'price_low_high':
        return Icons.arrow_upward;
      case 'price_high_low':
        return Icons.arrow_downward;
      case 'year_new_old':
        return Icons.calendar_today;
      case 'year_old_new':
        return Icons.calendar_month;
      case 'mileage_low_high':
        return Icons.speed;
      case 'date_new_old':
        return Icons.schedule;
      default:
        return Icons.sort;
    }
  }

  Widget _buildSearchResults(ThemeData theme) {
    return Consumer<CarsProvider>(
      builder: (context, carsProvider, child) {
        if (carsProvider.cars == null) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.search,
                    size: 64.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'Search for cars',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        final filteredCars = _getFilteredAndSortedCars(carsProvider.cars!);

        if (filteredCars.isEmpty) {
          return SliverFillRemaining(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.car_rental,
                    size: 64.sp,
                    color: theme.colorScheme.onSurface.withValues(alpha: 0.3),
                  ),
                  SizedBox(height: 16.h),
                  Text(
                    'No cars found',
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    'Try adjusting your filters',
                    style: TextStyle(
                      fontSize: 14.sp,
                      color: theme.colorScheme.onSurface.withValues(alpha: 0.4),
                    ),
                  ),
                ],
              ),
            ),
          );
        }

        return SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) {
              final car = filteredCars[index];
              return CarLisTile(
                car: car,
                index: index,
              );
            },
            childCount: filteredCars.length,
          ),
        );
      },
    );
  }

  List<CarEntity> _getFilteredAndSortedCars(List<CarEntity> cars) {
    List<CarEntity> filteredCars = cars.where((car) {
      // Search query filter
      if (_searchQuery.isNotEmpty) {
        final searchLower = _searchQuery.toLowerCase();
        final titleMatch =
            car.title?.toLowerCase().contains(searchLower) ?? false;
        final makeMatch =
            car.make?.toLowerCase().contains(searchLower) ?? false;
        final modelMatch =
            car.model?.toLowerCase().contains(searchLower) ?? false;
        final descriptionMatch =
            car.description?.toLowerCase().contains(searchLower) ?? false;

        if (!titleMatch && !makeMatch && !modelMatch && !descriptionMatch) {
          return false;
        }
      }

      // Price range filter
      if (car.price != null) {
        if (car.price! < _priceRange.start || car.price! > _priceRange.end) {
          return false;
        }
      }

      // Make filter
      if (_selectedMake != null && car.make != _selectedMake) {
        return false;
      }

      // Model filter
      if (_selectedModel != null && car.model != _selectedModel) {
        return false;
      }

      // Year filter
      if (_selectedYear != null && car.year != _selectedYear) {
        return false;
      }

      // Transmission filter
      if (_selectedTransmission != null &&
          car.transmission != _selectedTransmission) {
        return false;
      }

      // Fuel filter
      if (_selectedFuel != null && car.fuel != _selectedFuel) {
        return false;
      }

      // Category filter (basic implementation - you might want to enhance this)
      if (_selectedCategory != null) {
        // This is a simplified category matching - you might want to add category field to CarEntity
        final carTitle = car.title?.toLowerCase() ?? '';
        if (!carTitle.contains(_selectedCategory!.toLowerCase())) {
          return false;
        }
      }

      return true;
    }).toList();

    // Sort cars
    switch (_sortBy) {
      case 'price_low_high':
        filteredCars.sort((a, b) => (a.price ?? 0).compareTo(b.price ?? 0));
        break;
      case 'price_high_low':
        filteredCars.sort((a, b) => (b.price ?? 0).compareTo(a.price ?? 0));
        break;
      case 'year_new_old':
        filteredCars.sort((a, b) => (b.year ?? 0).compareTo(a.year ?? 0));
        break;
      case 'year_old_new':
        filteredCars.sort((a, b) => (a.year ?? 0).compareTo(b.year ?? 0));
        break;
      case 'mileage_low_high':
        filteredCars.sort((a, b) => (a.mileage ?? 0).compareTo(b.mileage ?? 0));
        break;
      case 'date_new_old':
        filteredCars.sort((a, b) => (b.updatedAt ?? DateTime.now())
            .compareTo(a.updatedAt ?? DateTime.now()));
        break;
      case 'relevance':
      default:
        // Relevance sorting - prioritize search matches
        if (_searchQuery.isNotEmpty) {
          filteredCars.sort((a, b) {
            final aScore = _getRelevanceScore(a);
            final bScore = _getRelevanceScore(b);
            return bScore.compareTo(aScore);
          });
        }
        break;
    }

    return filteredCars;
  }

  int _getRelevanceScore(CarEntity car) {
    int score = 0;
    final searchLower = _searchQuery.toLowerCase();

    if (car.title?.toLowerCase().contains(searchLower) ?? false) {
      score += 10;
    }
    if (car.make?.toLowerCase().contains(searchLower) ?? false) {
      score += 8;
    }
    if (car.model?.toLowerCase().contains(searchLower) ?? false) {
      score += 8;
    }
    if (car.description?.toLowerCase().contains(searchLower) ?? false) {
      score += 5;
    }

    return score;
  }
}
