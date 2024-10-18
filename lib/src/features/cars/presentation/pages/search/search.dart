import 'package:car_app_beta/core/widgets/text_fields.dart';
import 'package:car_app_beta/src/features/cars/business/entities/car_list_entity.dart';
import 'package:car_app_beta/src/features/cars/presentation/providers/cars_provider.dart';
import 'package:car_app_beta/src/features/cars/presentation/widgets/car_list_tile.dart';
import 'package:flutter/material.dart';
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
        toolbarHeight: 100,
        title: CustomTextField(
          prefixIcon: Icons.search,
          hintText: "Search...",
          onChanged: (query) {
            setState(() {
              _searchQuery = query;
            });
          },
        ),
        // bottom: TabBar(
        //   controller: _tabController,
        //   tabs: const [
        //     Tab(text: "By Date"),
        //     Tab(text: "By Popularity"),
        //     Tab(text: "By Rating"),
        //   ],
        // ),
      ),
      body: SearchResultsTab(searchQuery: _searchQuery),
      //  TabBarView(
      //   controller: _tabController,
      //   children: [

      //     //   SearchResultsTab(sortBy: "Popularity", searchQuery: _searchQuery),
      //     //   SearchResultsTab(sortBy: "Rating", searchQuery: _searchQuery),
      //   ],
      // ),
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
      List<CarEntity> filteredItems = cars.cars!
          .where((item) =>
              item.title!.toLowerCase().contains(searchQuery.toLowerCase()))
          .toList();

      // if (sortBy == "Date") {
      //   filteredItems.sort((a, b) => b["date"]!.compareTo(a["date"]!));
      // } else if (sortBy == "Popularity") {
      //   // Example of sorting by popularity; you'd adjust this logic as needed.
      //   filteredItems
      //       .sort((a, b) => b["popularity"]!.compareTo(a["popularity"]!));
      // } else if (sortBy == "Rating") {
      //   filteredItems.sort((a, b) => b["rating"]!.compareTo(a["rating"]!));
      // }
      return ListView.builder(
        itemCount: cars.isloaded! ? filteredItems.length : 5,
        itemBuilder: (context, index) {
          return cars.isloaded!
              ? CarLisTile(car: filteredItems[index])
              : const CarListLoadingTile();
        },
      );
    });
  }
}
