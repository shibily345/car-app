import 'package:car_app_beta/src/features/skeleton/model/rive_ani_model.dart';

class NavItemModel {
  final String title;
  final RiveModel rive;

  NavItemModel({required this.title, required this.rive});
}

List<RiveModel> bottomNavItemsDark = [
  RiveModel(
      src: "assets/data/white_icon.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity"),
  RiveModel(
      src: "assets/data/white_icon.riv",
      artboard: "SEARCH",
      stateMachineName: "SEARCH_Interactivity"),
  RiveModel(
      src: "assets/data/white_icon.riv",
      artboard: "LIKE/STAR",
      stateMachineName: "STAR_Interactivity"),
  RiveModel(
      src: "assets/data/white_icon.riv",
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity"),
];

List<RiveModel> bottomNavItemsLight = [
  RiveModel(
      src: "assets/data/black_icons.riv",
      artboard: "HOME",
      stateMachineName: "HOME_interactivity"),
  RiveModel(
      src: "assets/data/black_icons.riv",
      artboard: "USER",
      stateMachineName: "USER_Interactivity"),
  RiveModel(
      src: "assets/data/black_icons.riv",
      artboard: "TIMER",
      stateMachineName: "TIMER_Interactivity"),
  RiveModel(
      src: "assets/data/black_icons.riv",
      artboard: "SETTINGS",
      stateMachineName: "SETTINGS_Interactivity"),
];
