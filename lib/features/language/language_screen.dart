import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../core/storage/local_storage.dart';
import '../../core/theme/app_colors.dart';
import '../controllers.dart';

class _Lang {
  const _Lang(this.code, this.name, this.flag, {this.isDefault = false});
  final String code;
  final String name;
  final String flag;
  final bool isDefault;
}

const _languages = [
  _Lang('en', 'English', '🇬🇧', isDefault: true),
  _Lang('ar', 'Arabic', '🇸🇦'),
  _Lang('de', 'German', '🇩🇪'),
  _Lang('it', 'Italian', '🇮🇹'),
  _Lang('fr', 'French', '🇫🇷'),
  _Lang('hi', 'Hindi', '🇮🇳'),
  _Lang('es', 'Spanish', '🇪🇸'),
  _Lang('af', 'Afrikaans', '🇿🇦'),
];

class LanguageScreen extends ConsumerWidget {
  const LanguageScreen({super.key, this.fromSettings = false});

  final bool fromSettings;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selected = ref.watch(localeProvider).languageCode;

    return Scaffold(
      backgroundColor: AppColors.page(context),
      appBar: AppBar(
        backgroundColor: AppColors.primary,
        foregroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            if (fromSettings || Navigator.of(context).canPop()) {
              context.pop();
            }
          },
        ),
        title: const Text(
          'Select Language',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12, top: 10, bottom: 10),
            child: FilledButton(
              style: FilledButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: AppColors.primary,
                minimumSize: const Size(84, 36),
                padding: const EdgeInsets.symmetric(horizontal: 18),
                shape: const StadiumBorder(),
              ),
              onPressed: () async {
                await ref.read(localeProvider.notifier).setLanguage(selected);
                if (!context.mounted) return;
                if (fromSettings) {
                  context.pop();
                } else if (!ref.read(localStorageProvider).hasSeenPro) {
                  context.go('/pro');
                } else {
                  context.go('/home');
                }
              },
              child: const Text('Next'),
            ),
          ),
        ],
      ),
      body: GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
        itemCount: _languages.length,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 14,
          crossAxisSpacing: 14,
          childAspectRatio: 1.35,
        ),
        itemBuilder: (context, index) {
          final item = _languages[index];
          final isSelected = selected == item.code;
          return Material(
            color: isSelected ? AppColors.primary : AppColors.card(context),
            elevation: 0,
            shadowColor: Colors.transparent,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
              side: BorderSide(
                color: isSelected ? AppColors.primaryLight : AppColors.border(context),
                width: 1.2,
              ),
            ),
            child: InkWell(
              borderRadius: BorderRadius.circular(18),
              onTap: () => ref.read(localeProvider.notifier).setLanguage(item.code),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.flag, style: const TextStyle(fontSize: 28)),
                    const Spacer(),
                    Text(
                      item.isDefault ? '${item.name} (Default)' : item.name,
                      style: TextStyle(
                        color: isSelected ? Colors.white : AppColors.text(context),
                        fontWeight: FontWeight.w600,
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}
