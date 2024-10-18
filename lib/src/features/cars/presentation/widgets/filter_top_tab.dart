import 'package:flutter/material.dart';

class FilterBar extends PreferredSize {
  const FilterBar(
      {required super.preferredSize, required super.child, super.key,});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return PreferredSize(
      preferredSize: preferredSize,
      child: Container(
        width: size.width,
        color: Colors.white,
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              TextButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.tune_rounded),
                label: const Text('Filter'),
              ),
              const FilterButton(label: 'All'),
              const FilterButton(label: 'Favorites'),
              const FilterButton(label: 'Popular'),
              const FilterButton(label: 'Recent'),
            ],
          ),
        ),
      ),
    );
  }
}

class FilterButton extends StatelessWidget {
  const FilterButton({required this.label, super.key});
  final String label;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        // Implement filter logic
      },
      style: TextButton.styleFrom(),
      child: Text(label),
    );
  }
}
