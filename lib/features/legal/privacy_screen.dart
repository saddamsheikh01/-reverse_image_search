import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class PrivacyScreen extends StatelessWidget {
  const PrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.privacyPolicy)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(l10n.appName, style: Theme.of(context).textTheme.headlineSmall),
          const SizedBox(height: 16),
          Text(l10n.privacyPolicyBody),
        ],
      ),
    );
  }
}
