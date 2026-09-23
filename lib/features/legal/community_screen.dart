import 'package:flutter/material.dart';

class CommunityScreen extends StatelessWidget {
  const CommunityScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Community Guidelines')),
      body: ListView(
        padding: EdgeInsets.all(20),
        children: [
          Text(
            'Use Deep Image Search for lawful image lookup only.\n\n'
            'Do not use this app to harass, stalk, impersonate, or exploit anyone. '
            'Do not search for or share sexual content involving minors.\n\n'
            'Respect other people\'s privacy and the copyright of images you find. '
            'Results come from third-party websites and remain under those sites\' terms.\n\n'
            'We may limit or refuse searches that abuse the service.',
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
