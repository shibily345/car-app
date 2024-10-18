import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/selected_page_provider.dart';
import 'custom_bottom_bar_icon_widget.dart';

class CustomBottomBarWidget extends StatelessWidget {
  const CustomBottomBarWidget({super.key});

  @override
  Widget build(BuildContext context) {
    int selectedPage = Provider.of<SelectedPageProvider>(context).selectedPage;

    return BottomAppBar(
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Align(
          //   alignment: selectedPage == 0
          //       ? Alignment.centerLeft
          //       : Alignment.centerRight,
          //   child: LayoutBuilder(
          //     builder: (context, box) => SizedBox(
          //       width: box.maxWidth / 3,
          //       child: const Divider(
          //         height: 0,
          //         color: Colors.orangeAccent,
          //         thickness: 2,
          //       ),
          //     ),
          //   ),
          // ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              CustomBottomBarIconWidget(
                iconDataSelected: Icons.home,
                iconDataUnselected: Icons.home_filled,
                callback: () {
                  Provider.of<SelectedPageProvider>(context, listen: false)
                      .changePage(0);
                },
                isSelected: selectedPage == 0,
              ),
              CustomBottomBarIconWidget(
                iconDataSelected: Icons.add_box_outlined,
                iconDataUnselected: Icons.add_box_rounded,
                callback: () {
                  Provider.of<SelectedPageProvider>(context, listen: false)
                      .changePage(1);
                },
                isSelected: selectedPage == 1,
              ),
              CustomBottomBarIconWidget(
                iconDataSelected: Icons.settings,
                iconDataUnselected: Icons.stacked_bar_chart,
                callback: () {
                  Provider.of<SelectedPageProvider>(context, listen: false)
                      .changePage(2);
                },
                isSelected: selectedPage == 2,
              ),
            ],
          ),
        ],
      ),
    );
  }
}
