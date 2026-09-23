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
          Text(
            'Deep Image Search processes images you pick, capture, or provide by URL so we can perform reverse image searches through SerpApi Google Lens.\n\n'
            'Local photos are uploaded to a temporary file host so the search provider can read them. We do not keep uploaded images on a custom server.\n\n'
            'Search results are retrieved from third-party websites. Those websites remain the source of the images and may have their own copyright and terms.\n\n'
            'History and favorites stay on this device. Analytics events such as app opens, search started, and search completed may be collected. We do not collect image contents in analytics.\n\n'
            'Subscriptions are processed by Apple or Google. We do not store payment card details.\n\n'
            'You can delete local history and remove favorites from the app.',
          ),
        ],
      ),
    );
  }
}
