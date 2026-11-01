import 'package:flutter/material.dart';
import 'package:sportify/core/theme/app_colors.dart';

/// Compact floating header with Sportify logo badge and action icons.
class FeedHeader extends StatelessWidget {
  const FeedHeader({
    super.key,
    required this.searchActive,
    required this.onSearchTap,
    required this.onChatTap,
    this.onUploadTap,
  });

  final bool searchActive;
  final VoidCallback onSearchTap;
  final VoidCallback onChatTap;
  final VoidCallback? onUploadTap;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;

    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  green.withValues(alpha: 0.2),
                  green.withValues(alpha: 0.05),
                ],
              ),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: green.withValues(alpha: 0.3)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.sports_soccer_rounded, color: green, size: 18),
                SizedBox(width: 6),
                Text(
                  'Sportify',
                  style: TextStyle(
                    color: green,
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
          ),
          const Spacer(),
          if (onUploadTap != null) ...[
            GestureDetector(
              onTap: onUploadTap,
              child: Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                decoration: BoxDecoration(
                  color: green.withValues(alpha: 0.14),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: green.withValues(alpha: 0.45)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded, color: green, size: 18),
                    SizedBox(width: 4),
                    Text(
                      'Post',
                      style: TextStyle(color: green, fontSize: 12.5, fontWeight: FontWeight.w800),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
          _HeaderIcon(
            icon: searchActive ? Icons.close_rounded : Icons.search_rounded,
            active: searchActive,
            onTap: onSearchTap,
          ),
          const SizedBox(width: 8),
          _HeaderIcon(
            icon: Icons.chat_bubble_outline_rounded,
            onTap: onChatTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderIcon extends StatelessWidget {
  const _HeaderIcon({
    required this.icon,
    required this.onTap,
    this.active = false,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool active;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: active
              ? green.withValues(alpha: 0.15)
              : const Color(0xFF0E1822),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: active ? green : const Color(0xFF1B2A38),
          ),
        ),
        child: Icon(
          icon,
          color: active ? green : Colors.white70,
          size: 20,
        ),
      ),
    );
  }
}

/// Horizontal scrollable position filter strip.
class FeedFilterStrip extends StatelessWidget {
  const FeedFilterStrip({
    super.key,
    required this.filters,
    required this.selected,
    required this.onSelected,
  });

  final List<String> filters;
  final String selected;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    const green = AppColors.green2;
    const card = Color(0xFF0E1822);
    const border = Color(0xFF1B2A38);

    return SizedBox(
      height: 38,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = filters[i];
          final isSel = f == selected;

          return GestureDetector(
            onTap: () => onSelected(f),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSel ? green : card,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(color: isSel ? green : border),
              ),
              child: Text(
                f,
                style: TextStyle(
                  color: isSel ? Colors.black : Colors.white70,
                  fontWeight: isSel ? FontWeight.w800 : FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

