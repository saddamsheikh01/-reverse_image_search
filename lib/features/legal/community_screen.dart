import 'package:flutter/material.dart';

import '../../l10n/app_localizations.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(l10n.communityGuidelines)),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          Text(
            l10n.communityGuidelinesBody,
            style: TextStyle(
              height: 1.5,
              fontSize: 15,
              color: Theme.of(context).colorScheme.onSurface,
            ),
          ),
        ],
      ),
    );
  }
}
