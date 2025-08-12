import 'package:car_app_beta/core/widgets/text.dart';
import 'package:car_app_beta/src/features/auth/presentation/providers/auth_provider.dart';
import 'package:car_app_beta/src/features/settings/settings_controller.dart';
import 'package:car_app_beta/src/widgets/overlays/styled_overlays.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<SettingsProvider>(
      builder: (context, settingsProvider, state) {
        return Scaffold(
          backgroundColor: Theme.of(context).colorScheme.surface,
          appBar: AppBar(
            title: const Text("Settings"),
            backgroundColor: Theme.of(context).colorScheme.primary,
            foregroundColor: Theme.of(context).colorScheme.onPrimary,
          ),
          body: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Appearance Section
                _buildSectionHeader(context, 'Appearance'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.palette,
                  title: 'Theme',
                  subtitle: _getThemeModeText(settingsProvider.themeMode),
                  color: Colors.indigo,
                  onTap: () => settingsProvider.showThemeDialog(
                      context, _DummyLocalization()),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.globe,
                  title: 'Language',
                  subtitle: _getLanguageText(settingsProvider.locale),
                  color: Colors.teal,
                  onTap: () => settingsProvider.showLanguageDialog(
                      _DummyLocalization(), context),
                ),

                const SizedBox(height: 24),

                // Account Section
                _buildSectionHeader(context, 'Account'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.userEdit,
                  title: 'Edit Profile',
                  subtitle: 'Update your information',
                  color: Colors.blue,
                  onTap: () => _showEditProfileDialog(context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.bell,
                  title: 'Notifications',
                  subtitle: 'Manage notification preferences',
                  color: Colors.orange,
                  onTap: () => _showNotificationsDialog(context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.shieldAlt,
                  title: 'Privacy & Security',
                  subtitle: 'Manage your privacy settings',
                  color: Colors.green,
                  onTap: () => _showPrivacyDialog(context),
                ),

                const SizedBox(height: 24),

                // Payment Section
                _buildSectionHeader(context, 'Payment & Billing'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.creditCard,
                  title: 'Payment Methods',
                  subtitle: 'Manage your payment options',
                  color: Colors.purple,
                  onTap: () => _showComingSoon(context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.receipt,
                  title: 'Billing History',
                  subtitle: 'View your transaction history',
                  color: Colors.amber,
                  onTap: () => _showComingSoon(context),
                ),

                const SizedBox(height: 24),

                // Data & Storage
                _buildSectionHeader(context, 'Data & Storage'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.download,
                  title: 'Download Data',
                  subtitle: 'Export your data',
                  color: Colors.blue,
                  onTap: () => _showComingSoon(context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.trash,
                  title: 'Clear Cache',
                  subtitle: 'Free up storage space',
                  color: Colors.red,
                  onTap: () => _showClearCacheDialog(context),
                ),

                const SizedBox(height: 24),

                // Support Section
                _buildSectionHeader(context, 'Support'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.questionCircle,
                  title: 'Help Center',
                  subtitle: 'Get help and support',
                  color: Colors.blue,
                  onTap: () => _launchUrl('https://help.carapp.com'),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.headset,
                  title: 'Contact Support',
                  subtitle: 'Reach out to our team',
                  color: Colors.green,
                  onTap: () => _showContactSupportDialog(context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.bug,
                  title: 'Report a Bug',
                  subtitle: 'Help us improve the app',
                  color: Colors.red,
                  onTap: () => _showReportBugDialog(context),
                ),

                const SizedBox(height: 24),

                // Legal Section
                _buildSectionHeader(context, 'Legal'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.fileContract,
                  title: 'Terms of Service',
                  subtitle: 'Read our terms',
                  color: Colors.grey,
                  onTap: () => _launchUrl('https://carapp.com/terms'),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.userShield,
                  title: 'Privacy Policy',
                  subtitle: 'Read our privacy policy',
                  color: Colors.grey,
                  onTap: () => _launchUrl('https://carapp.com/privacy'),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.infoCircle,
                  title: 'About',
                  subtitle: 'App version and information',
                  color: Colors.grey,
                  onTap: () => _showAboutDialog(context),
                ),

                const SizedBox(height: 24),

                // Danger Zone
                _buildSectionHeader(context, 'Danger Zone'),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.signOutAlt,
                  title: 'Log Out',
                  subtitle: 'Sign out of your account',
                  color: Colors.red,
                  onTap: () => settingsProvider.showLogoutDialog(
                      _DummyLocalization(), context),
                ),
                _buildSettingsTile(
                  context,
                  icon: FontAwesomeIcons.userTimes,
                  title: 'Delete Account',
                  subtitle: 'Permanently delete your account',
                  color: Colors.red,
                  onTap: () => _showDeleteAccountDialog(context),
                ),

                const SizedBox(height: 32),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextDef(
        title,
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildSettingsTile(
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

  String _getThemeModeText(ThemeMode? themeMode) {
    switch (themeMode) {
      case ThemeMode.light:
        return 'Light Mode';
      case ThemeMode.dark:
        return 'Dark Mode';
      case ThemeMode.system:
      default:
        return 'System Default';
    }
  }

  String _getLanguageText(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'hi':
        return 'Hindi';
      case 'ar':
        return 'Arabic';
      default:
        return 'English';
    }
  }

  // Dialog Methods
  void _showEditProfileDialog(BuildContext context) {
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

  void _showClearCacheDialog(BuildContext context) {
    StyledDialog.show(
      context: context,
      title: 'Clear Cache',
      message:
          'Are you sure you want to clear the app cache? This will free up storage space.',
      actions: [
        DialogAction(
          label: "Cancel",
          onPressed: () => Navigator.of(context).pop(),
        ),
        DialogAction(
          isPrimary: true,
          label: "Clear",
          onPressed: () {
            Navigator.of(context).pop();
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Cache cleared successfully!')),
            );
          },
        ),
      ],
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

  void _showReportBugDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Report a Bug'),
        content: const Text('Bug reporting feature coming soon!'),
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
          'Are you sure you want to delete your account? This action cannot be undone and all your data will be permanently lost.',
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
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                  content: Text('Account deletion feature coming soon!')),
            );
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
    // Implementation for launching URLs
    // This would require url_launcher package
  }
}

// Dummy localization class for compatibility
class _DummyLocalization {
  String get selectLanguage => 'Select Language';
  String get selectTheme => 'Select Theme';
  String get confirmLogout => 'Are you sure you want to logout?';
  String get confirm => 'Confirm';
}
