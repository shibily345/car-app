import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:car_app_beta/src/widgets/cards/glass_card.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

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
        if (up.firebaseUser != null) {
          return SingleChildScrollView(
            child: Column(
              children: [
                // User Info Section

                GlassCard(
                  width: sz.width,
                  height: 80,
                  // margin: const EdgeInsets.all(20.0),
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      up.firebaseUser!.photoURL == null
                          ? const SizedBox.shrink()
                          : CircleAvatar(
                              radius: 20,
                              backgroundImage:
                                  NetworkImage(up.firebaseUser!.photoURL!),
                            ),
                      const SizedBox(width: 16),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          up.firebaseUser!.displayName == null
                              ? const SizedBox.shrink()
                              : TextDef(
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
                    ? _ProfileSectionTile(
                        icon: FontAwesomeIcons.cartShopping,
                        color: Theme.of(context).colorScheme.primary,
                        title: 'Garrage',
                        description: 'Manage your Store',
                        action: () {
                          Navigator.pushNamed(context, "/myShop");
                        },
                      )
                    : _ProfileSectionTile(
                        icon: FontAwesomeIcons.plus,
                        color: Theme.of(context).colorScheme.primary,
                        title: 'Satrt Selling',
                        description: 'Became a seller',
                        action: () {
                          Navigator.pushNamed(context, "/addSeller");
                        },
                      ),
                _ProfileSectionTile(
                  icon: FontAwesomeIcons.powerOff,
                  color: Colors.red,
                  title: 'Log Out',
                  description: 'Logout from this account',
                  action: () {
                    StyledDialog.show(
                        context: context,
                        title: 'Confirm Logout',
                        actions: [
                          DialogAction(
                              label: "Cancel",
                              onPressed: () => Navigator.of(context).pop()),
                          DialogAction(
                              isPrimary: true,
                              label: "Logout",
                              onPressed: () {
                                context
                                    .read<AuthenticationProvider>()
                                    .logout(context);
                              })
                        ]);
                    // context.read<AuthenticationProvider>().logout(context);
                  },
                ),
              ],
            ),
          );
        } else {
          return const LoginButton();
        }
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: _ProfileSectionTile(
          icon: icon ?? FontAwesomeIcons.shop,
          color: Colors.red,
          title: label ?? '',
          description: '',
          action: onTap ?? () {}),
    );
  }
}

class _ProfileSectionTile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  final VoidCallback action;

  const _ProfileSectionTile({
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
    required this.action,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return InkWell(
      onTap: action,
      child: Padding(
        padding: const EdgeInsets.only(left: 16.0, right: 16.0, bottom: 8.0),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: theme.colorScheme.surface,
            borderRadius: BorderRadius.circular(16),
            border:
                Border.all(color: theme.colorScheme.outline.withOpacity(0.1)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 20, color: color),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      description,
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withOpacity(0.7),
                      ),
                    ),
                  ],
                ),
              ),
              // GlassButton(label: title, onPressed: action),
            ],
          ),
        ),
      ),
    );
  }
}
