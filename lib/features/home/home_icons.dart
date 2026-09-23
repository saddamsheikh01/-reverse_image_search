import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../../core/theme/app_colors.dart';

class HomeTileIcon extends StatelessWidget {
  const HomeTileIcon({super.key, required this.kind});

  final HomeIconKind kind;

  @override
  Widget build(BuildContext context) {
    const color = AppColors.primary;
    switch (kind) {
      case HomeIconKind.face:
        return const Icon(Icons.person_outline, color: color, size: 28);
      case HomeIconKind.twitter:
        return const FaIcon(FontAwesomeIcons.twitter, color: color, size: 22);
      case HomeIconKind.plant:
        return const FaIcon(FontAwesomeIcons.seedling, color: color, size: 22);
      case HomeIconKind.photo:
        return const Icon(Icons.image_outlined, color: color, size: 26);
      case HomeIconKind.globe:
        return const Icon(Icons.language, color: color, size: 26);
      case HomeIconKind.duplicate:
        return const SizedBox(
          width: 26,
          height: 26,
          child: Stack(
            children: [
              Positioned(
                left: 4,
                top: 0,
                child: Icon(Icons.image_outlined, color: color, size: 18),
              ),
              Positioned(
                left: 0,
                bottom: 0,
                child: Icon(Icons.image_outlined, color: color, size: 18),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Icon(Icons.autorenew, color: color, size: 12),
              ),
            ],
          ),
        );
    }
  }
}

enum HomeIconKind { face, twitter, plant, photo, globe, duplicate }

class ProChip extends StatelessWidget {
  const ProChip({
    super.key,
    this.label = 'Pro',
    this.compact = false,
    this.onTap,
  });

  final String label;
  final bool compact;
  final VoidCallback? onTap;

  static const Color fill = Color(0xFFF5D15C);

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 10 : 14,
        vertical: compact ? 4 : 7,
      ),
      decoration: BoxDecoration(
        color: fill,
        borderRadius: BorderRadius.circular(99),
      ),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.w700,
          fontSize: compact ? 11 : 13,
        ),
      ),
    );
    if (onTap == null) return child;
    return GestureDetector(onTap: onTap, child: child);
  }
}
