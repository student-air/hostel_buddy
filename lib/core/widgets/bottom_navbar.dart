import 'dart:ui';

import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class AppBottomNavItem {
  const AppBottomNavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
  });

  final IconData icon;
  final IconData activeIcon;
  final String label;
}

class AppBottomNavBar extends StatelessWidget {
  const AppBottomNavBar({
    super.key,
    required this.selectedIndex,
    required this.onTap,
    this.items = defaultItems,
  });

  final int selectedIndex;
  final ValueChanged<int> onTap;
  final List<AppBottomNavItem> items;

  static const List<AppBottomNavItem> defaultItems = [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    AppBottomNavItem(
      icon: Icons.description_outlined,
      activeIcon: Icons.description_rounded,
      label: 'Bids',
    ),
    AppBottomNavItem(
      icon: Icons.search_rounded,
      activeIcon: Icons.search_rounded,
      label: 'Search',
    ),
    AppBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  static const List<AppBottomNavItem> managerItems = [
    AppBottomNavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Home',
    ),
    AppBottomNavItem(
      icon: Icons.gavel_outlined,
      activeIcon: Icons.gavel_rounded,
      label: 'Bids',
    ),
    AppBottomNavItem(
      icon: Icons.meeting_room_outlined,
      activeIcon: Icons.meeting_room_rounded,
      label: 'Rooms',
    ),
    AppBottomNavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profile',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Padding(
      padding: EdgeInsets.fromLTRB(18, 0, 18, 10 + bottomPad),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(36),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: Container(
            height: 68,
            padding: const EdgeInsets.symmetric(horizontal: 6),
            decoration: BoxDecoration(
              color: AppColors.surfaceWhite.withValues(alpha: 0.82),
              borderRadius: BorderRadius.circular(36),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: List.generate(items.length, (i) {
                final item = items[i];
                final selected = selectedIndex == i;

                return GestureDetector(
                  onTap: () => onTap(i),
                  behavior: HitTestBehavior.opaque,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 240),
                    curve: Curves.easeOutCubic,
                    padding: EdgeInsets.symmetric(
                      horizontal: selected ? 16 : 14,
                      vertical: 11,
                    ),
                    decoration: BoxDecoration(
                      color:
                          selected ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(28),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: AppColors.primary
                                    .withValues(alpha: 0.3),
                                blurRadius: 12,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : null,
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          selected ? item.activeIcon : item.icon,
                          size: 24,
                          color: selected
                              ? Colors.white
                              : AppColors.textMuted,
                        ),
                        if (selected) ...[
                          const SizedBox(width: 7),
                          Text(
                            item.label,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                );
              }),
            ),
          ),
        ),
      ),
    );
  }
}