import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  String _searchQuery = "";

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          backgroundColor: Colors.transparent,
          toolbarHeight: 100,
          title: Padding(
            padding: EdgeInsets.symmetric(horizontal: 0.w, vertical: 5.h),
            child: GestureDetector(
              onTap: () => Navigator.pushNamed(context, "/search"),
              child: TextFormField(
                onChanged: (query) {
                  setState(() {
                    _searchQuery = query;
                  });
                },
                decoration: InputDecoration(
                  contentPadding:
                      EdgeInsets.symmetric(horizontal: 20.w, vertical: 15.h),
                  filled: true,
                  fillColor: Theme.of(context).primaryColor.withOpacity(0.1),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(20),
                    borderSide: BorderSide(
                      color: Theme.of(context).colorScheme.primary,
                      width: 2,
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.search,
                    color: Theme.of(context).colorScheme.onPrimary,
                  ),
                  hintText: "Search here...",
                  hintStyle: TextStyle(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.6),
                    fontSize: 18.sp,
                  ),
                ),
              ),
            ),
          )),
      body: SearchResultsTab(searchQuery: _searchQuery),
    );
  }
}

class SearchResultsTab extends StatelessWidget {
  // final String sortBy;
  final String searchQuery;

  const SearchResultsTab({super.key, required this.searchQuery});

  @override
  Widget build(BuildContext context) {
    // Filter and sort items based on the search query and sorting method

    return Consumer<CarsProvider>(builder: (context, cars, state) {
      if (cars.cars != null) {
        List<CarEntity> filteredItems = cars.cars!
            .where((item) =>
                item.title!.toLowerCase().contains(searchQuery.toLowerCase()))
            .toList();

        return ListView.builder(
          itemCount: cars.cars == null ? filteredItems.length : 5,
          itemBuilder: (context, index) {
            return cars.isloaded!
                ? CarLisTile(car: filteredItems[index])
                : const CarListLoadingTile();
          },
        );
      }
      return const CarListLoadingTile();

      // if (sortBy == "Date") {
      //   filteredItems.sort((a, b) => b["date"]!.compareTo(a["date"]!));
      // } else if (sortBy == "Popularity") {
      //   // Example of sorting by popularity; you'd adjust this logic as needed.
      //   filteredItems
      //       .sort((a, b) => b["popularity"]!.compareTo(a["popularity"]!));
      // } else if (sortBy == "Rating") {
      //   filteredItems.sort((a, b) => b["rating"]!.compareTo(a["rating"]!));
      // }
    });
  }
}
