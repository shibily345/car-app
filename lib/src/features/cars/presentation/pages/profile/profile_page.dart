import 'package:car_app_beta/core/widgets/containers.dart';
import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/extensions.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  final String userName = "John Doe";
  final String userEmail = "john.doe@example.com";
  final String userAvatar =
      "assets/avatar.png"; // Add a default image in your assets folder
  final List<Map<String, String>> carListings = [
    {"title": "2022 Tesla Model S", "image": "assets/car1.png"},
    {"title": "2021 BMW X5", "image": "assets/car2.png"},
    {"title": "2020 Audi Q7", "image": "assets/car3.png"},
  ];

  ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);
    var sz = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        title: const Text("Profile"),
      ),
      body: Consumer<UserProvider>(builder: (context, up, _) {
        return SingleChildScrollView(
          child: Column(
            children: [
              // User Info Section
              CustomContainer(
                width: sz.width,
                height: 80,
                margin: const EdgeInsets.all(20.0),
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  children: [
                    CircleAvatar(
                      radius: 20,
                      backgroundImage: NetworkImage(up.firebaseUser!.photoURL!),
                    ),
                    const SizedBox(width: 16),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        TextDef(
                          up.firebaseUser!.displayName!,
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                        ),
                        const SizedBox(height: 4),
                        TextDef(
                          up.firebaseUser!.email!,
                          fontSize: 12,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 20),

              up.isSeller
                  ? ProfileTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/addNew");
                      },
                      icon: Icons.add,
                      label: "My Shop",
                    )
                  : ProfileTile(
                      onTap: () {
                        Navigator.pushNamed(context, "/addSeller");
                      },
                      icon: Icons.add,
                      label: "Be A Seller",
                    ),

              ProfileTile(
                onTap: () {
                  context.read<AuthenticationProvider>().logout(context);
                },
                icon: Icons.logout,
                label: "Logout",
              ),

              ProfileTile(
                onTap: () {
                  // Navigator.pushNamed(context, "/addNew");
                },
                icon: Icons.color_lens,
                label: "Theme",
              ),

              ProfileTile(
                onTap: () {
                  // Navigator.pushNamed(context, "/addNew");
                },
                icon: Icons.language,
                label: "Language",
              ),
            ],
          ),
        );
      }),
    );
  }
}

class ProfileTile extends StatelessWidget {
  final String? label;
  final IconData? icon;
  final VoidCallback? onTap;

  const ProfileTile({
    super.key,
    this.label,
    this.icon,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return CustomContainer(
      margin: const EdgeInsets.only(left: 20, right: 20, top: 10),
      height: 70,
      ontap: onTap ??
          () {
            context.read<AuthenticationProvider>().logout(context);
          },
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          20.spaceX,
          Icon(icon ?? Icons.color_lens_outlined),
          20.spaceX,
          TextDef(label ?? "Theme"),
        ],
      ),
    );
  }
}
