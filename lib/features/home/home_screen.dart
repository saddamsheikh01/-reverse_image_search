import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:image_picker/image_picker.dart';

import '../../core/errors/app_exception.dart';
import '../../core/theme/app_colors.dart';
import '../../core/utils/picked_media.dart';
import '../../core/utils/url_validator.dart';
import '../../core/widgets/app_widgets.dart';
import '../../models/search_type.dart';
import '../../models/user_models.dart';
import '../../services/analytics_service.dart';
import '../controllers.dart';
import 'app_drawer.dart';
import 'home_icons.dart';
import 'image_source_sheet.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key, this.focusSearch = false});

  final bool focusSearch;

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeMode {
  const _HomeMode({
    required this.title,
    required this.subtitle,
    required this.icon,
    this.badge = '',
    this.pro = false,
    this.social = false,
  });

  final String title;
  final String subtitle;
  final HomeIconKind icon;
  final String badge;
  final bool pro;
  final bool social;
}

class _HomeScreenState extends ConsumerState<HomeScreen> {
  final _name = TextEditingController();

  static const _modes = [
    _HomeMode(
      title: 'AI Face Analysis',
      subtitle: 'Use camera or select from gallery for analyzation.',
      icon: HomeIconKind.face,
      badge: 'New',
    ),
    _HomeMode(
      title: 'Social Media Deep Search',
      subtitle: 'Use social platforms for analyzation.',
      icon: HomeIconKind.twitter,
      badge: 'New',
      social: true,
    ),
    _HomeMode(
      title: 'AI Object & Landmark',
      subtitle: 'Use camera or select from gallery for recognition.',
      icon: HomeIconKind.plant,
    ),
    _HomeMode(
      title: 'Similar Faces from gallery',
      subtitle: 'Use Gallery to detect Face.',
      icon: HomeIconKind.photo,
      badge: 'Pro',
      pro: true,
    ),
    _HomeMode(
      title: 'Search from Web',
      subtitle: 'Use camera or select from gallery to search from Web.',
      icon: HomeIconKind.globe,
    ),
    _HomeMode(
      title: 'Duplicate Images',
      subtitle: 'Clean up your gallery delete duplicate images',
      icon: HomeIconKind.duplicate,
    ),
  ];

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  Future<void> _openMode(_HomeMode mode) async {
    if (mode.pro) {
      context.push('/subscription');
      return;
    }
    if (mode.social) {
      context.push('/social-search');
      return;
    }
    await _pickAndSearch();
  }

  Future<void> _pickAndSearch() async {
    final typed = _name.text.trim();
    if (UrlValidator.isValidHttpUrl(typed)) {
      ref.read(searchControllerProvider.notifier).setPending(PendingImage(remoteUrl: typed));
      if (mounted) context.push('/searching', extra: SearchType.all.apiValue);
      return;
    }

    final source = await ImageSourceSheet.show(context);
    if (source == null || !mounted) return;

    try {
      if (source == ImageSource.gallery) {
        await ref.read(analyticsServiceProvider).galleryOpened();
      }
      final file = await PickedMedia.pickOriginal(source: source);
      if (file == null || !mounted) return;
      await ref.read(analyticsServiceProvider).imageSelected();
      ref.read(searchControllerProvider.notifier).setPending(
            PendingImage(localPath: file.path),
          );
      if (mounted) context.push('/searching', extra: SearchType.all.apiValue);
    } on AppException catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(error.message)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final textColor = AppColors.text(context);
    final muted = AppColors.muted(context);
    final cardColor = AppColors.card(context);

    return Scaffold(
      backgroundColor: AppColors.page(context),
      drawer: const AppDrawer(),
      body: Column(
        children: [
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              gradient: AppColors.heroGradient,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: SafeArea(
              bottom: false,
              child: Padding(
                padding: const EdgeInsets.fromLTRB(8, 6, 16, 28),
                child: Column(
                  children: [
                    Row(
                      children: [
                        SizedBox(
                          width: 72,
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: Builder(
                              builder: (context) => IconButton(
                                onPressed: () => Scaffold.of(context).openDrawer(),
                                icon: const Icon(Icons.menu, color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        const Expanded(
                          child: Text(
                            'Deep Image Search',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                        SizedBox(
                          width: 72,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: ProChip(onTap: () => context.push('/subscription')),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 18),
                    const Text(
                      'Who are you\nlooking for?',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                    ),
                    const SizedBox(height: 18),
                    AppTextField(
                      controller: _name,
                      hint: 'Type full name...',
                      prefix: const Icon(Icons.search, color: AppColors.mutedLight),
                      onSubmitted: (_) => _pickAndSearch(),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 20, 16, 24),
              itemCount: _modes.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final mode = _modes[index];
                return Material(
                  color: cardColor,
                  elevation: 1,
                  shadowColor: const Color(0x14000000),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(22),
                    side: BorderSide(color: AppColors.border(context), width: 1.2),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(22),
                    onTap: () => _openMode(mode),
                    child: Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.fromLTRB(16, 16, 52, 16),
                          child: Row(
                            children: [
                              HomeTileIcon(kind: mode.icon),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      mode.title,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 16,
                                        color: textColor,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      mode.subtitle,
                                      style: TextStyle(
                                        color: muted,
                                        fontSize: 13,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                        if (mode.badge.isNotEmpty)
                          Positioned(
                            top: 0,
                            right: 0,
                            child: ProChip(label: mode.badge, compact: true),
                          ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
