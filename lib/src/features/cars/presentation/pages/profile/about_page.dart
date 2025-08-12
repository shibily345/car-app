import 'package:car_app_beta/core/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final th = Theme.of(context);

    return Scaffold(
      backgroundColor: th.colorScheme.surface,
      appBar: AppBar(
        title: const Text('About'),
        backgroundColor: th.colorScheme.primary,
        foregroundColor: th.colorScheme.onPrimary,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // App Logo and Version
            _buildAppHeader(context),
            const SizedBox(height: 32),

            // App Description
            _buildSectionHeader(context, 'About Car App'),
            _buildInfoCard(
              context,
              content:
                  'Car App is your trusted platform for car rentals and sales. '
                  'We connect car owners with renters, making car sharing simple, '
                  'secure, and convenient. Whether you need a car for a day or '
                  'want to rent out your vehicle, we\'ve got you covered.',
            ),
            const SizedBox(height: 24),

            // Features
            _buildSectionHeader(context, 'Key Features'),
            _buildFeatureList(context),
            const SizedBox(height: 24),

            // Version Information
            _buildSectionHeader(context, 'Version Information'),
            _buildVersionInfo(context),
            const SizedBox(height: 24),

            // Team
            _buildSectionHeader(context, 'Our Team'),
            _buildTeamInfo(context),
            const SizedBox(height: 24),

            // Contact
            _buildSectionHeader(context, 'Contact Us'),
            _buildContactInfo(context),
            const SizedBox(height: 24),

            // Legal Links
            _buildSectionHeader(context, 'Legal'),
            _buildLegalLinks(context),
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }

  Widget _buildAppHeader(BuildContext context) {
    final th = Theme.of(context);

    return Center(
      child: Column(
        children: [
          // App Logo
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              color: th.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Icon(
              FontAwesomeIcons.car,
              size: 50,
              color: th.colorScheme.primary,
            ),
          ),
          const SizedBox(height: 16),

          // App Name
          TextDef(
            'Car App',
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: th.colorScheme.primary,
          ),
          const SizedBox(height: 8),

          // Version
          TextDef(
            'Version 1.0.8 (Beta)',
            fontSize: 16,
            color: th.colorScheme.onSurface.withOpacity(0.7),
          ),
          const SizedBox(height: 8),

          // Build Number
          TextDef(
            'Build 8',
            fontSize: 14,
            color: th.colorScheme.onSurface.withOpacity(0.5),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextDef(
        title,
        fontSize: 20,
        fontWeight: FontWeight.bold,
        color: Theme.of(context).colorScheme.primary,
      ),
    );
  }

  Widget _buildInfoCard(BuildContext context, {required String content}) {
    final th = Theme.of(context);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: TextDef(
        content,
        fontSize: 16,
        height: 1.5,
        color: th.colorScheme.onSurface.withOpacity(0.8),
      ),
    );
  }

  Widget _buildFeatureList(BuildContext context) {
    final features = [
      {
        'icon': FontAwesomeIcons.car,
        'title': 'Car Rentals',
        'description': 'Rent cars from local owners'
      },
      {
        'icon': FontAwesomeIcons.store,
        'title': 'Car Sales',
        'description': 'Buy and sell cars easily'
      },
      {
        'icon': FontAwesomeIcons.shieldAlt,
        'title': 'Secure Payments',
        'description': 'Safe and secure transactions'
      },
      {
        'icon': FontAwesomeIcons.mapLocationDot,
        'title': 'Location Services',
        'description': 'Find cars near you'
      },
      {
        'icon': FontAwesomeIcons.star,
        'title': 'Reviews & Ratings',
        'description': 'Trusted community feedback'
      },
      {
        'icon': FontAwesomeIcons.headset,
        'title': '24/7 Support',
        'description': 'Always here to help'
      },
    ];

    return Column(
      children: features
          .map((feature) => _buildFeatureTile(context, feature))
          .toList(),
    );
  }

  Widget _buildFeatureTile(BuildContext context, Map<String, dynamic> feature) {
    final th = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: th.colorScheme.primary.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(
              feature['icon'] as IconData,
              size: 20,
              color: th.colorScheme.primary,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextDef(
                  feature['title'] as String,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
                TextDef(
                  feature['description'] as String,
                  fontSize: 14,
                  color: th.colorScheme.onSurface.withOpacity(0.7),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVersionInfo(BuildContext context) {
    final th = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildInfoRow('App Version', '1.0.8'),
          _buildInfoRow('Build Number', '8'),
          _buildInfoRow('Platform', 'Flutter'),
          _buildInfoRow('Framework Version', '3.5.0'),
          _buildInfoRow('Last Updated', 'December 2024'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextDef(
            label,
            fontSize: 14,
            color: Colors.grey[600],
          ),
          TextDef(
            value,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ],
      ),
    );
  }

  Widget _buildTeamInfo(BuildContext context) {
    final th = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          TextDef(
            'Car App is developed by a passionate team dedicated to making car sharing accessible to everyone.',
            fontSize: 16,
            height: 1.5,
            color: th.colorScheme.onSurface.withOpacity(0.8),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildTeamMember('Development', 'Flutter Team'),
              _buildTeamMember('Design', 'UI/UX Team'),
              _buildTeamMember('Support', 'Customer Care'),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTeamMember(String role, String team) {
    return Column(
      children: [
        TextDef(
          role,
          fontSize: 14,
          fontWeight: FontWeight.w600,
        ),
        TextDef(
          team,
          fontSize: 12,
          color: Colors.grey[600],
        ),
      ],
    );
  }

  Widget _buildContactInfo(BuildContext context) {
    final th = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildContactTile(
            context,
            icon: FontAwesomeIcons.envelope,
            title: 'Email',
            subtitle: 'support@carapp.com',
            onTap: () => _launchEmail('support@carapp.com'),
          ),
          _buildContactTile(
            context,
            icon: FontAwesomeIcons.phone,
            title: 'Phone',
            subtitle: '+1 (555) 123-4567',
            onTap: () => _launchPhone('+15551234567'),
          ),
          _buildContactTile(
            context,
            icon: FontAwesomeIcons.globe,
            title: 'Website',
            subtitle: 'www.carapp.com',
            onTap: () => _launchUrl('https://www.carapp.com'),
          ),
          _buildContactTile(
            context,
            icon: FontAwesomeIcons.locationDot,
            title: 'Address',
            subtitle: '123 Car Street, Auto City, AC 12345',
            onTap: null,
          ),
        ],
      ),
    );
  }

  Widget _buildContactTile(
    BuildContext context, {
    required IconData icon,
    required String title,
    required String subtitle,
    VoidCallback? onTap,
  }) {
    final th = Theme.of(context);

    return ListTile(
      contentPadding: EdgeInsets.zero,
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: th.colorScheme.primary.withOpacity(0.1),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(icon, size: 16, color: th.colorScheme.primary),
      ),
      title: TextDef(
        title,
        fontSize: 14,
        fontWeight: FontWeight.w600,
      ),
      subtitle: TextDef(
        subtitle,
        fontSize: 12,
        color: th.colorScheme.onSurface.withOpacity(0.7),
      ),
      onTap: onTap,
    );
  }

  Widget _buildLegalLinks(BuildContext context) {
    final th = Theme.of(context);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: th.colorScheme.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: th.colorScheme.outline.withOpacity(0.1)),
      ),
      child: Column(
        children: [
          _buildLegalTile(
            context,
            'Terms of Service',
            () => _launchUrl('https://carapp.com/terms'),
          ),
          _buildLegalTile(
            context,
            'Privacy Policy',
            () => _launchUrl('https://carapp.com/privacy'),
          ),
          _buildLegalTile(
            context,
            'Cookie Policy',
            () => _launchUrl('https://carapp.com/cookies'),
          ),
          _buildLegalTile(
            context,
            'Data Protection',
            () => _launchUrl('https://carapp.com/data-protection'),
          ),
        ],
      ),
    );
  }

  Widget _buildLegalTile(
      BuildContext context, String title, VoidCallback onTap) {
    return ListTile(
      contentPadding: EdgeInsets.zero,
      title: TextDef(
        title,
        fontSize: 14,
        color: Theme.of(context).colorScheme.primary,
      ),
      trailing: const Icon(Icons.arrow_forward_ios, size: 16),
      onTap: onTap,
    );
  }

  Future<void> _launchEmail(String email) async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    }
  }

  Future<void> _launchPhone(String phone) async {
    final Uri phoneUri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    }
  }

  Future<void> _launchUrl(String url) async {
    final Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}
