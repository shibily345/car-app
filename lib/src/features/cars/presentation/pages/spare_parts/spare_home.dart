import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class SparePartsHome extends StatelessWidget {
  const SparePartsHome({super.key});

  void _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'support@carapp.com',
      query: 'subject=Suggestion for Spare Parts Feature&body=Hi Team,',
    );

    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Spare Parts - Coming Soon'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                '🔧 Spare Parts - Coming Soon!',
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'We are excited to announce that the Spare Parts feature is coming soon in our next update! Here\'s what you can expect:',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              const Text(
                '✨ Features to Look Forward To:',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const BulletPoint(text: 'Wide range of spare parts available.'),
              const BulletPoint(text: 'Affordable pricing and genuine parts.'),
              const BulletPoint(text: 'Easy ordering process.'),
              const BulletPoint(text: '24/7 customer support.'),
              const BulletPoint(text: 'Real-time stock availability updates.'),
              const SizedBox(height: 24),
              const Text(
                'Have suggestions for us?',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'We would love to hear your thoughts and ideas! Feel free to send us your suggestions.',
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 16),
              Center(
                child: ElevatedButton.icon(
                  onPressed: _sendEmail,
                  icon: const Icon(Icons.email),
                  label: const Text('Send Suggestions'),
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class BulletPoint extends StatelessWidget {
  final String text;

  const BulletPoint({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '• ',
            style: TextStyle(fontSize: 16),
          ),
          Expanded(
            child: Text(
              text,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
