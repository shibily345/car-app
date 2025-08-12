import 'package:car_app_beta/src/features/cars/presentation/widgets/rental_car_tile.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/rental/presentation/providers/rental_provider.dart';
import 'package:car_app_beta/src/features/rental/business/entities/rental_entity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_animate/flutter_animate.dart';

class RentCarHome extends StatefulWidget {
  const RentCarHome({super.key});

  @override
  State<RentCarHome> createState() => _RentCarHomeState();
}

class _RentCarHomeState extends State<RentCarHome>
    with TickerProviderStateMixin {
  late AnimationController _filterController;
  late AnimationController _sortController;

  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  String _searchQuery = '';
  bool _isFilterExpanded = false;
  bool _isSortExpanded = false;

  // Filter states
  String _selectedRentalType = 'All';
  String _selectedSort = 'Newest';
  String? _selectedMake;

  // Available options
  final List<String> _rentalTypes = [
    'All',
    'Daily',
    'Weekly',
    'Monthly',
    'Hourly'
  ];
  final List<String> _sortOptions = ['Newest', 'Price ↑', 'Price ↓'];

  @override
  void initState() {
    super.initState();
    _filterController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _sortController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    WidgetsBinding.instance.addPostFrameCallback((_) {
      Provider.of<CarsProvider>(context, listen: false).eitherFailureOrCars();
      Provider.of<RentalProvider>(context, listen: false).getAllRentals();
    });

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text;
      });
    });
  }

  @override
  void dispose() {
    _filterController.dispose();
    _sortController.dispose();
    _searchController.dispose();
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
      _selectedRentalType = 'All';
      _selectedSort = 'Newest';
      _selectedMake = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final size = MediaQuery.of(context).size;

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: Consumer2<CarsProvider, RentalProvider>(
        builder: (context, carsProvider, rentalProvider, _) {
          if (carsProvider.cars == null ||
              rentalProvider.allRentalsState == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final rentCars =
              carsProvider.cars!.where((car) => car.isForRent == true).toList();
          final filteredCars = _applySearch(rentCars);
          final rentals = rentalProvider.allRentalsState?.data ?? [];
          final makes = rentCars
              .map((car) => car.make)
              .where((make) => make != null && make.isNotEmpty)
              .toSet()
              .toList();

          if (filteredCars.isEmpty) {
            return Scaffold(
              appBar: AppBar(
                title: Text(
                  'Rent a Car',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 20.sp,
                  ),
                ),
                backgroundColor: theme.colorScheme.surface,
                elevation: 0,
              ),
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.car_rental,
                        size: 64.sp,
                        color: theme.colorScheme.onSurface.withOpacity(0.3)),
                    SizedBox(height: 16.h),
                    Text('No rental cars found',
                        style: TextStyle(
                            fontSize: 18.sp,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.6))),
                    SizedBox(height: 8.h),
                    Text('Try adjusting your search',
                        style: TextStyle(
                            fontSize: 14.sp,
                            color:
                                theme.colorScheme.onSurface.withOpacity(0.4))),
                  ],
                ),
              ),
            );
          }

          // Apply rental type filter
          List<CarEntity> carsToShow = filteredCars.where((car) {
            if (_selectedRentalType == 'All') return true;
            final rental = rentals.where((r) => r.carId == car.id).isNotEmpty
                ? rentals.firstWhere((r) => r.carId == car.id)
                : null;
            if (rental == null) return false;
            return rental.rentalType.toLowerCase() ==
                _selectedRentalType.toLowerCase();
          }).toList();

          // Apply make filter
          if (_selectedMake != null && _selectedMake!.isNotEmpty) {
            carsToShow =
                carsToShow.where((car) => car.make == _selectedMake).toList();
          }

          // Apply sorting
          carsToShow.sort((a, b) {
            final rentalA = rentals.where((r) => r.carId == a.id).isNotEmpty
                ? rentals.firstWhere((r) => r.carId == a.id)
                : null;
            final rentalB = rentals.where((r) => r.carId == b.id).isNotEmpty
                ? rentals.firstWhere((r) => r.carId == b.id)
                : null;
            switch (_selectedSort) {
              case 'Price ↑':
                final priceA =
                    _getPriceForRentalType(rentalA, _selectedRentalType) ??
                        a.price ??
                        0;
                final priceB =
                    _getPriceForRentalType(rentalB, _selectedRentalType) ??
                        b.price ??
                        0;
                return priceA.compareTo(priceB);
              case 'Price ↓':
                final priceA =
                    _getPriceForRentalType(rentalA, _selectedRentalType) ??
                        a.price ??
                        0;
                final priceB =
                    _getPriceForRentalType(rentalB, _selectedRentalType) ??
                        b.price ??
                        0;
                return priceB.compareTo(priceA);
              case 'Newest':
              default:
                return (b.updatedAt ?? DateTime(1970))
                    .compareTo(a.updatedAt ?? DateTime(1970));
            }
          });

          return CustomScrollView(
            slivers: [
              // Custom App Bar with Search
              _buildSliverAppBar(theme, size),

              // Filter and Sort Controls
              _buildFilterSortControls(theme, makes),

              // Results Count
              _buildResultsCount(carsToShow.length, theme),

              // Search Results
              _buildSearchResults(theme, carsToShow, rentals),
            ],
          );
        },
      ),
    );
  }

  Widget _buildSliverAppBar(ThemeData theme, Size size) {
    return SliverAppBar(
      expandedHeight: 120.h,
      floating: false,
      pinned: true,
      elevation: 0,
      backgroundColor: theme.colorScheme.surface,
      title: Text(
        'Rent a Car',
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
                controller: _searchController,
                focusNode: _searchFocusNode,
                decoration: InputDecoration(
                  hintText: 'Search for cars by make, model, or features...',
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
                  _searchController.clear();
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

  Widget _buildFilterSortControls(ThemeData theme, List<String?> makes) {
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
          _buildFilterPanel(theme, makes),

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

  Widget _buildFilterPanel(ThemeData theme, List<String?> makes) {
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

                // Rental Type Filter
                _buildRentalTypeFilter(theme),
                SizedBox(height: 20.h),

                // Make Filter
                _buildMakeFilter(theme, makes),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildRentalTypeFilter(ThemeData theme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Rental Type',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
        DropdownButtonFormField<String>(
          value: _selectedRentalType,
          decoration: InputDecoration(
            labelText: 'Select Rental Type',
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.r),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16.w,
              vertical: 12.h,
            ),
          ),
          items: _rentalTypes
              .map((type) => DropdownMenuItem<String>(
                    value: type,
                    child: Text(type),
                  ))
              .toList(),
          onChanged: (value) {
            setState(() {
              _selectedRentalType = value!;
            });
          },
        ),
      ],
    );
  }

  Widget _buildMakeFilter(ThemeData theme, List<String?> makes) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Car Make',
          style: TextStyle(
            fontSize: 16.sp,
            fontWeight: FontWeight.w600,
            color: theme.colorScheme.onSurface,
          ),
        ),
        SizedBox(height: 10.h),
        Row(
          children: [
            Expanded(
              child: DropdownButtonFormField<String?>(
                value: _selectedMake,
                decoration: InputDecoration(
                  labelText: 'Select Make',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.r),
                  ),
                  contentPadding: EdgeInsets.symmetric(
                    horizontal: 16.w,
                    vertical: 12.h,
                  ),
                ),
                items: [
                  const DropdownMenuItem<String?>(
                    value: null,
                    child: Text('All Makes'),
                  ),
                  ...makes.map((make) => DropdownMenuItem<String?>(
                        value: make,
                        child: Text(make ?? ''),
                      )),
                ],
                onChanged: (value) {
                  setState(() {
                    _selectedMake = value;
                  });
                },
              ),
            ),
            if (_selectedMake != null) ...[
              SizedBox(width: 10.w),
              Container(
                decoration: BoxDecoration(
                  color: theme.colorScheme.error.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(12.r),
                  border: Border.all(
                    color: theme.colorScheme.error.withValues(alpha: 0.3),
                  ),
                ),
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _selectedMake = null;
                      });
                    },
                    borderRadius: BorderRadius.circular(12.r),
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        vertical: 12.h,
                        horizontal: 16.w,
                      ),
                      child: Icon(
                        Icons.clear,
                        color: theme.colorScheme.error,
                        size: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ],
        ),
      ],
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
    final isSelected = _selectedSort == option;
    final icon = _getSortOptionIcon(option);

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          setState(() {
            _selectedSort = option;
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
                  option,
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

  IconData _getSortOptionIcon(String option) {
    switch (option) {
      case 'Newest':
        return Icons.schedule;
      case 'Price ↑':
        return Icons.arrow_upward;
      case 'Price ↓':
        return Icons.arrow_downward;
      default:
        return Icons.sort;
    }
  }

  Widget _buildResultsCount(int count, ThemeData theme) {
    return SliverToBoxAdapter(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 12.h),
        child: Row(
          children: [
            Icon(
              Icons.car_rental,
              size: 16.sp,
              color: theme.colorScheme.primary,
            ),
            SizedBox(width: 8.w),
            Text(
              '$count rental car${count != 1 ? 's' : ''} found',
              style: TextStyle(
                fontSize: 14.sp,
                fontWeight: FontWeight.w500,
                color: theme.colorScheme.onSurface.withValues(alpha: 0.7),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSearchResults(
      ThemeData theme, List<CarEntity> carsToShow, List<RentalEntity> rentals) {
    if (carsToShow.isEmpty) {
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
          final car = carsToShow[index];
          final rental = rentals.where((r) => r.carId == car.id).isNotEmpty
              ? rentals.firstWhere((r) => r.carId == car.id)
              : null;
          return RentalCarTile(
            car: car,
            rental: rental,
            index: index,
            selectedRentalType: _selectedRentalType,
          );
        },
        childCount: carsToShow.length,
      ),
    );
  }

  double? _getPriceForRentalType(
      RentalEntity? rental, String? selectedRentalType) {
    if (rental == null) return null;

    if (selectedRentalType != null && selectedRentalType != 'All') {
      // Use the selected rental type from filter
      switch (selectedRentalType.toLowerCase()) {
        case 'hourly':
          return rental.pricing.hourly;
        case 'daily':
          return rental.pricing.daily;
        case 'weekly':
          return rental.pricing.weekly;
        case 'monthly':
          return rental.pricing.monthly;
      }
    } else {
      // When "All" is selected, use the actual rental type of the car
      switch (rental.rentalType.toLowerCase()) {
        case 'hourly':
          return rental.pricing.hourly;
        case 'daily':
          return rental.pricing.daily;
        case 'weekly':
          return rental.pricing.weekly;
        case 'monthly':
          return rental.pricing.monthly;
        default:
          // Fallback to original logic if rental type is not recognized
          return rental.pricing.daily ??
              rental.pricing.hourly ??
              rental.pricing.weekly ??
              rental.pricing.monthly;
      }
    }

    return null;
  }

  List<CarEntity> _applySearch(List<CarEntity> cars) {
    if (_searchQuery.isEmpty) return cars;
    final query = _searchQuery.toLowerCase();
    return cars.where((car) {
      final title = car.title?.toLowerCase() ?? '';
      final make = car.make?.toLowerCase() ?? '';
      final model = car.model?.toLowerCase() ?? '';
      final description = car.description?.toLowerCase() ?? '';
      return title.contains(query) ||
          make.contains(query) ||
          model.contains(query) ||
          description.contains(query);
    }).toList();
  }
}
