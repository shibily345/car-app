import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/user_provider.dart';
import 'package:car_app_beta/src/widgets/buttons/login_button.dart';
import 'package:car_app_beta/src/widgets/cards/glass_card.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ProfilePage extends StatelessWidget {
  final ScrollController? scrollController;
  const ProfilePage({super.key, this.scrollController});

  @override
  Widget build(BuildContext context) {
    var th = Theme.of(context);

    return Scaffold(
      backgroundColor: th.colorScheme.surface,
      body: Consumer<UserProvider>(builder: (context, up, _) {
        if (up.firebaseUser != null) {
          return CustomScrollView(
            controller: scrollController,
            slivers: [
              // Custom App Bar
              SliverAppBar(
                expandedHeight: 120.h,
                floating: false,
                pinned: true,
                backgroundColor: th.colorScheme.primary,
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    "Profile",
                    style: TextStyle(
                      color: th.colorScheme.onPrimary,
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                    ),
                  ),
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          th.colorScheme.primary,
                          th.colorScheme.primary.withAlpha(204),
                        ],
                      ),
                    ),
                  ),
                ),
                actions: [
                  IconButton(
                    icon: Icon(
                      Icons.settings,
                      color: th.colorScheme.onPrimary,
                      size: 24.sp,
                    ),
                    onPressed: () {
                      Navigator.pushNamed(context, "/settings");
                    },
                  ),
                ],
              ),

              // Profile Content
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.all(16.w),
                  child: Column(
                    children: [
                      // User Profile Header
                      _buildProfileHeader(context, up, th),
                      SizedBox(height: 24.h),

                      // Quick Stats
                      _buildQuickStats(context, up, th),
                      SizedBox(height: 24.h),

                      // Main Menu Sections
                      _buildMainMenu(context, up, th),
                      SizedBox(height: 24.h),

                      // Account & Settings
                      _buildAccountSection(context, up, th),
                      SizedBox(height: 24.h),

                      // Support & Legal
                      _buildSupportSection(context, up, th),
                      SizedBox(height: 24.h),

                      // Logout Section
                      _buildLogoutSection(context, up, th),
                      SizedBox(height: 32.h),
                    ],
                  ),
                ),
              ),
            ],
          );
        } else {
          return const LoginButton();
        }
      }),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context, UserProvider up, ThemeData th) {
    return GlassCard(
      width: double.infinity,
      height: 130.h,
      padding: EdgeInsets.all(20.w),
      child: Row(
        children: [
          // Profile Picture
          Container(
            width: 80.w,
            height: 80.h,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                color: th.colorScheme.primary.withAlpha(77),
                width: 3.w,
              ),
            ),
            child: ClipOval(
              child: up.firebaseUser!.photoURL != null
                  ? Image.network(
                      up.firebaseUser!.photoURL!,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: th.colorScheme.primary.withAlpha(26),
                          child: Icon(
                            Icons.person,
                            size: 40.sp,
                            color: th.colorScheme.primary,
                          ),
                        );
                      },
                    )
                  : Container(
                      color: th.colorScheme.primary.withAlpha(26),
                      child: Icon(
                        Icons.person,
                        size: 40.sp,
                        color: th.colorScheme.primary,
                      ),
                    ),
            ),
          ),
          SizedBox(width: 20.w),

          // User Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextDef(
                  up.firebaseUser!.displayName ?? 'User',
                  fontSize: 20.sp,
                  fontWeight: FontWeight.bold,
                ),
                SizedBox(height: 4.h),
                TextDef(
                  up.firebaseUser!.email!,
                  fontSize: 14.sp,
                  color: th.colorScheme.onSurface.withAlpha(179),
                ),
                SizedBox(height: 8.h),
                Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 12.w, vertical: 4.h),
                  decoration: BoxDecoration(
                    color: up.isSeller
                        ? Colors.green.withAlpha(26)
                        : Colors.blue.withAlpha(26),
                    borderRadius: BorderRadius.circular(20.r),
                  ),
                  child: TextDef(
                    up.isSeller ? 'Seller' : 'Customer',
                    fontSize: 12.sp,
                    fontWeight: FontWeight.w600,
                    color: up.isSeller ? Colors.green : Colors.blue,
                  ),
                ),
              ],
            ),
          ),

          // Edit Button
          IconButton(
            onPressed: () => _showEditProfileDialog(context, up),
            icon: Icon(
              Icons.edit,
              color: th.colorScheme.primary,
              size: 24.sp,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickStats(BuildContext context, UserProvider up, ThemeData th) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.heart,
            title: 'Favorites',
            value: '${up.currentFavorites.length}',
            color: Colors.red,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.car,
            title: 'Rentals',
            value: '0',
            color: Colors.blue,
          ),
        ),
        SizedBox(width: 12.w),
        Expanded(
          child: _buildStatCard(
            context,
            icon: FontAwesomeIcons.star,
            title: 'Reviews',
            value: '0',
            color: Colors.amber,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String value,
    required Color color,
  }) {
    final th = Theme.of(context);

    return Container(
      padding: EdgeInsets.all(16.w),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(16.r),
        border: Border.all(color: th.colorScheme.outline.withAlpha(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: Offset(0, 2.h),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withAlpha(26),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, size: 20, color: color),
          ),
          const SizedBox(height: 8),
          TextDef(
            value,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
          TextDef(
            title,
            fontSize: 12,
            color: th.colorScheme.onSurface.withAlpha(179),
          ),
        ],
      ),
    );
  }

  Widget _buildMainMenu(BuildContext context, UserProvider up, ThemeData th) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Quick Actions',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),

        // Seller/Customer specific actions
        if (up.isSeller) ...[
          _buildMenuTile(
            context,
            icon: FontAwesomeIcons.store,
            title: 'My Garage',
            subtitle: 'Manage your vehicles',
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, "/myShop"),
          ),
          _buildMenuTile(
            context,
            icon: FontAwesomeIcons.chartLine,
            title: 'Analytics',
            subtitle: 'View your performance',
            color: Colors.purple,
            onTap: () => _showComingSoon(context),
          ),
        ] else ...[
          _buildMenuTile(
            context,
            icon: FontAwesomeIcons.plus,
            title: 'Become a Seller',
            subtitle: 'Start selling your cars',
            color: Colors.green,
            onTap: () => Navigator.pushNamed(context, "/addSeller"),
          ),
        ],

        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.heart,
          title: 'My Favorites',
          subtitle: 'View saved cars',
          color: Colors.red,
          onTap: () => Navigator.pushNamed(context, "/favorite"),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.history,
          title: 'Rental History',
          subtitle: 'View past rentals',
          color: Colors.blue,
          onTap: () => _showComingSoon(context),
        ),
      ],
    );
  }

  Widget _buildAccountSection(
      BuildContext context, UserProvider up, ThemeData th) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Account & Settings',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.userEdit,
          title: 'Edit Profile',
          subtitle: 'Update your information',
          color: Colors.blue,
          onTap: () => _showEditProfileDialog(context, up),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.bell,
          title: 'Notifications',
          subtitle: 'Manage notifications',
          color: Colors.orange,
          onTap: () => _showNotificationsDialog(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.shieldAlt,
          title: 'Privacy & Security',
          subtitle: 'Manage your privacy',
          color: Colors.green,
          onTap: () => _showPrivacyDialog(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.creditCard,
          title: 'Payment Methods',
          subtitle: 'Manage payment options',
          color: Colors.purple,
          onTap: () => _showComingSoon(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.globe,
          title: 'Language',
          subtitle: 'Change app language',
          color: Colors.teal,
          onTap: () => _showLanguageDialog(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.palette,
          title: 'Theme',
          subtitle: 'Light or dark mode',
          color: Colors.indigo,
          onTap: () => _showThemeDialog(context),
        ),
      ],
    );
  }

  Widget _buildSupportSection(
      BuildContext context, UserProvider up, ThemeData th) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const TextDef(
          'Support & Legal',
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        const SizedBox(height: 16),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.questionCircle,
          title: 'Help Center',
          subtitle: 'Get help and support',
          color: Colors.blue,
          onTap: () => _launchUrl('https://help.carapp.com'),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.headset,
          title: 'Contact Support',
          subtitle: 'Reach out to our team',
          color: Colors.green,
          onTap: () => _showContactSupportDialog(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.infoCircle,
          title: 'About Us',
          subtitle: 'Learn more about the app',
          color: Colors.purple,
          onTap: () => _showAboutDialog(context),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.fileContract,
          title: 'Terms of Service',
          subtitle: 'Read our terms',
          color: Colors.grey,
          onTap: () => _launchUrl('https://carapp.com/terms'),
        ),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.userShield,
          title: 'Privacy Policy',
          subtitle: 'Read our privacy policy',
          color: Colors.grey,
          onTap: () => _launchUrl('https://carapp.com/privacy'),
        ),
      ],
    );
  }

  Widget _buildLogoutSection(
      BuildContext context, UserProvider up, ThemeData th) {
    return Column(
      children: [
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.trash,
          title: 'Delete Account',
          subtitle: 'Permanently delete your account',
          color: Colors.red,
          onTap: () => _showDeleteAccountDialog(context),
        ),
        const SizedBox(height: 16),
        _buildMenuTile(
          context,
          icon: FontAwesomeIcons.signOutAlt,
          title: 'Log Out',
          subtitle: 'Sign out of your account',
          color: Colors.red,
          onTap: () => _showLogoutDialog(context),
        ),
      ],
    );
  }

  Widget _buildMenuTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
    required VoidCallback onTap,
  }) {
    final th = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: th.colorScheme.outline.withAlpha(26)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withAlpha(13),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        leading: Container(
          padding: const EdgeInsets.all(10),
          decoration: BoxDecoration(
            color: color.withAlpha(26),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, size: 20, color: color),
        ),
        title: TextDef(
          title,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        subtitle: TextDef(
          subtitle,
          fontSize: 12,
          color: th.colorScheme.onSurface.withAlpha(179),
        ),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 16,
          color: th.colorScheme.onSurface.withAlpha(128),
        ),
        onTap: onTap,
      ),
    );
  }

  // Dialog Methods
  void _showEditProfileDialog(BuildContext context, UserProvider up) {
    Navigator.pushNamed(context, "/editProfile");
  }

  void _showNotificationsDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Notifications'),
        content: const Text('Notification settings coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showPrivacyDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Privacy & Security'),
        content: const Text('Privacy settings coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showLanguageDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Language'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('English'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Hindi'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Arabic'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Theme'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              title: const Text('System Default'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Light Mode'),
              onTap: () => Navigator.pop(context),
            ),
            ListTile(
              title: const Text('Dark Mode'),
              onTap: () => Navigator.pop(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showContactSupportDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Contact Support'),
        content: const Text('Support contact feature coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showAboutDialog(BuildContext context) {
    Navigator.pushNamed(context, "/about");
  }

  void _showDeleteAccountDialog(BuildContext context) {
    StyledDialog.show(
      context: context,
      title: 'Delete Account',
      message:
          'Are you sure you want to delete your account? This action cannot be undone.',
      actions: [
        DialogAction(
          label: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
        ),
        DialogAction(
          isPrimary: true,
          label: "Delete",
          onPressed: () {
            Navigator.of(context).pop();
            // Add delete account logic here
          },
        ),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    StyledDialog.show(
      context: context,
      title: 'Confirm Logout',
      message: 'Are you sure you want to logout?',
      actions: [
        DialogAction(
          label: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
        ),
        DialogAction(
          isPrimary: true,
          label: "Logout",
          onPressed: () {
            Navigator.of(context).pop();
            context.read<AuthenticationProvider>().logout(context);
          },
        ),
      ],
    );
  }

  void _showComingSoon(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('This feature is coming soon!'),
        duration: Duration(seconds: 2),
      ),
    );
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

// Keep the existing ProfileTile and _ProfileSectionTile classes for backward compatibility
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
        action: onTap ?? () {},
      ),
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
            border: Border.all(color: theme.colorScheme.outline.withAlpha(26)),
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: color.withAlpha(26),
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
                        color: theme.colorScheme.onSurface.withAlpha(179),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
