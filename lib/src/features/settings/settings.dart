import 'package:car_app_beta/src/features/settings/settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    var ln = AppLocalizations.of(context)!;
    return Consumer<SettingsProvider>(
      builder: (context, set, state) {
        return Scaffold(
          appBar: AppBar(
            title: const Text("ln.settings"),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              ListTile(
                leading: const Icon(Icons.color_lens),
                title: const Text("ln.theme"),
                subtitle: Text(set.themeMode!.name),
                onTap: () {
                  set.showThemeDialog(context, ln);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.language),
                title: const Text("ln.languagen"),
                subtitle: const Text("ln.language"),
                onTap: () {
                  set.showLanguageDialog(ln, context);
                },
              ),
              const Divider(),
              ListTile(
                leading: const Icon(Icons.logout),
                title: const Text("ln.logOut"),
                onTap: () {
                  set.showLogoutDialog(ln, context);
                },
              ),
              const Divider(),
            ],
          ),
        );
      },
    );
  }
}
