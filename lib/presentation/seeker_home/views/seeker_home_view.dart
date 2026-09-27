import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/seeker_home_controller.dart';

class SeekerHomeView extends GetView<SeekerHomeController> {
  const SeekerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: controller.scaffoldKey,
        endDrawer: _SeekerDrawer(controller: controller),
        body: Stack(
          children: [
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B0E24),
                    Color(0xFF4A0A1E),
                    Color(0xFF2A0412),
                  ],
                ),
              ),
            ),
            Positioned(
              top: -60,
              right: -40,
              child: _Blob(
                size: 220,
                color: AppColors.accent.withValues(alpha: 0.08),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -50,
              child: _Blob(
                size: 180,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            SafeArea(
              bottom: false,
              child: Column(
                children: [
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _Header(controller: controller),
                          const SizedBox(height: 22),
                          _BidsGlance(controller: controller),
                          const SizedBox(height: 18),
                          _LocationRow(controller: controller),
                          const SizedBox(height: 18),
                          _QuickActions(controller: controller),
                          const SizedBox(height: 26),
                          _HostelsSection(controller: controller),
                        ],
                      ),
                    ),
                  ),
                  _BottomNav(controller: controller, bottomPad: bottomPad),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// HEADER
// ═══════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top bar: initials → profile | city | menu → drawer | notification → alerts
        Row(
          children: [
            // Initials → profile
            GestureDetector(
              onTap: controller.onProfile,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.3),
                  border: Border.all(
                    color: AppColors.accent.withValues(alpha: 0.6),
                  ),
                ),
                alignment: Alignment.center,
                child: Obx(() {
                  final _ = controller.userName.value;
                  return Text(
                    controller.initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 13,
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: GestureDetector(
                onTap: controller.onOtherCities,
                child: Row(
                  children: [
                    const Icon(
                      Icons.location_on_rounded,
                      size: 16,
                      color: AppColors.accentLight,
                    ),
                    const SizedBox(width: 4),
                    Flexible(
                      child: Obx(
                        () => Text(
                          controller.currentCity.value,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_rounded,
                      size: 18,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ],
                ),
              ),
            ),
            // Notification → alerts
            GestureDetector(
              onTap: controller.onNotifications,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withValues(alpha: 0.1),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.12),
                      ),
                    ),
                    child: const Icon(
                      Icons.notifications_none_rounded,
                      color: Colors.white,
                      size: 20,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 9,
                    child: Container(
                      width: 7,
                      height: 7,
                      decoration: const BoxDecoration(
                        color: AppColors.notificationDot,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            GestureDetector(
              onTap: controller.openDrawer,
              child: Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: 0.1),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                ),
                child: const Icon(
                  Icons.menu_rounded,
                  color: Colors.white,
                  size: 20,
                ),
              ),
            ),
            const SizedBox(width: 8),
          ],
        ),
        const SizedBox(height: 22),

        // Greeting + date card
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.greeting,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.65),
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      '${controller.userName.value}.',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.8,
                        height: 1.1,
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 5,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.45),
                      ),
                    ),
                    child: Obx(
                      () => Text(
                        controller.userRoleLabel.value,
                        style: const TextStyle(
                          color: AppColors.accentLight,
                          fontSize: 11.5,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Container(
              width: 118,
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.calendar_today_outlined,
                        size: 12,
                        color: Colors.white.withValues(alpha: 0.5),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        "Today's Date",
                        style: TextStyle(
                          color: Colors.white.withValues(alpha: 0.5),
                          fontSize: 10,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text(
                    controller.dateLabel,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  Text(
                    controller.weekdayLabel,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.55),
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      Icon(
                        controller.dayPart == 'Night'
                            ? Icons.nightlight_round
                            : Icons.wb_sunny_outlined,
                        size: 13,
                        color: AppColors.accentLight,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        controller.dayPart,
                        style: const TextStyle(
                          color: AppColors.accentLight,
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
// ═══════════════════════════════════════════
// BIDS GLANCE
// ═══════════════════════════════════════════

class _BidsGlance extends StatelessWidget {
  const _BidsGlance({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.16),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.22)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Expanded(
                    child: Text(
                      'Your bids at a glance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onViewAllBids,
                    child: const Text(
                      'View all',
                      style: TextStyle(
                        color: AppColors.accentLight,
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Obx(
                () => Row(
                  children: [
                    Expanded(
                      child: _StatCell(
                        value: '${controller.pendingBids.value}',
                        label: 'Pending',
                        valueColor: AppColors.warning,
                      ),
                    ),
                    _VDivider(),
                    Expanded(
                      child: _StatCell(
                        value: '${controller.acceptedBids.value}',
                        label: 'Accepted',
                        valueColor: AppColors.success,
                      ),
                    ),
                    _VDivider(),
                    Expanded(
                      child: _StatCell(
                        value: controller.avgOffer.value,
                        label: 'Avg. offer',
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({required this.value, required this.label, this.valueColor});

  final String value;
  final String label;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            color: valueColor ?? Colors.white,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.5),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}

class _VDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1,
      height: 36,
      color: Colors.white.withValues(alpha: 0.12),
    );
  }
}

// ═══════════════════════════════════════════
// LOCATION
// ═══════════════════════════════════════════

class _LocationRow extends StatelessWidget {
  const _LocationRow({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _GlassBox(
            child: Row(
              children: [
                const Icon(
                  Icons.location_on_rounded,
                  size: 18,
                  color: AppColors.accentLight,
                ),
                const SizedBox(width: 8),
                Obx(
                  () => Text(
                    controller.currentCity.value,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        GestureDetector(
          onTap: controller.onOtherCities,
          child: _GlassBox(
            child: Text(
              'Other cities',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.75),
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// QUICK ACTIONS
// ═══════════════════════════════════════════

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            label: 'Create bid',
            icon: Icons.add_rounded,
            filled: true,
            onTap: controller.onCreateBid,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            label: 'Map view',
            icon: Icons.map_outlined,
            filled: false,
            onTap: controller.onMapView,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            label: 'Saved',
            icon: Icons.favorite_border_rounded,
            filled: false,
            onTap: controller.onSaved,
          ),
        ),
      ],
    );
  }
}

class _ActionTile extends StatelessWidget {
  const _ActionTile({
    required this.label,
    required this.icon,
    required this.filled,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool filled;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 88,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(18),
          color: filled
              ? AppColors.accent
              : Colors.white.withValues(alpha: 0.08),
          border: filled
              ? null
              : Border.all(color: Colors.white.withValues(alpha: 0.1)),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.35),
                    blurRadius: 16,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: Colors.white, size: 26),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: Colors.white.withValues(alpha: filled ? 1 : 0.85),
                fontSize: 12,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// HOSTELS
// ═══════════════════════════════════════════

class _HostelsSection extends StatelessWidget {
  const _HostelsSection({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Hostels near you',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onSeeAllHostels,
              child: const Text(
                'See all',
                style: TextStyle(
                  color: AppColors.accentLight,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 14),
        Obx(
          () => Column(
            children: controller.hostels.map((h) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _HostelCard(
                  hostel: h,
                  onTap: () => controller.onHostelTap(h),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _HostelCard extends StatelessWidget {
  const _HostelCard({required this.hostel, required this.onTap});
  final Map<String, dynamic> hostel;
  final VoidCallback onTap;

  String _str(String key, [String fallback = '']) =>
      hostel[key]?.toString() ?? fallback;

  @override
  Widget build(BuildContext context) {
    final color = Color((hostel['color'] as int?) ?? 0xFF6B0E24);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.12),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 56,
              height: 56,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [color.withValues(alpha: 0.85), color],
                ),
              ),
              child: const Icon(
                Icons.verified_outlined,
                color: Colors.white,
                size: 26,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    _str('name', 'Hostel'),
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${_str('area')}, ${_str('city')} · ${_str('distance')}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    _str('price'),
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Row(
              children: [
                const Icon(
                  Icons.star_rounded,
                  size: 16,
                  color: Color(0xFFE0A33C),
                ),
                const SizedBox(width: 3),
                Text(
                  '${hostel['rating'] ?? '—'}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// BOTTOM NAV
// ═══════════════════════════════════════════

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.controller, required this.bottomPad});

  final SeekerHomeController controller;
  final double bottomPad;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.gavel_rounded, 'Bids'),
    (Icons.map_outlined, 'Map'),
    (Icons.chat_bubble_outline_rounded, 'Chat'),
    (Icons.person_outline_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(8, 10, 8, 10 + bottomPad),
      decoration: BoxDecoration(
        color: const Color(0xFF1F030E).withValues(alpha: 0.95),
        border: Border(
          top: BorderSide(color: Colors.white.withValues(alpha: 0.08)),
        ),
      ),
      child: Obx(
        () => Row(
          children: List.generate(_items.length, (i) {
            final selected = controller.selectedNavIndex.value == i;
            final item = _items[i];
            return Expanded(
              child: GestureDetector(
                onTap: () => controller.onNavTap(i),
                behavior: HitTestBehavior.opaque,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      item.$1,
                      size: 22,
                      color: selected
                          ? AppColors.accentLight
                          : Colors.white.withValues(alpha: 0.4),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      item.$2,
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: selected
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: selected
                            ? AppColors.accentLight
                            : Colors.white.withValues(alpha: 0.4),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// SIDE DRAWER (opened by notification icon)
// ═══════════════════════════════════════════

// ═══════════════════════════════════════════
// SIDE DRAWER
// ═══════════════════════════════════════════

class _SeekerDrawer extends StatelessWidget {
  const _SeekerDrawer({required this.controller});
  final SeekerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1A050C),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // ── Header ──
            Container(
              padding: const EdgeInsets.fromLTRB(20, 20, 12, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    AppColors.primary.withValues(alpha: 0.5),
                    Colors.transparent,
                  ],
                ),
              ),
              child: Row(
                children: [
                  // Avatar
                  GestureDetector(
                    onTap: () {
                      Navigator.pop(context);
                      controller.onProfile();
                    },
                    child: Container(
                      width: 56,
                      height: 56,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white,
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.accent.withValues(alpha: 0.3),
                            blurRadius: 12,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Obx(() {
                        final _ = controller.userName.value;
                        return Text(
                          controller.initials,
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                          ),
                        );
                      }),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 18,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                        ),
                        const SizedBox(height: 3),
                        Obx(
                          () => Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 3,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withValues(alpha: 0.18),
                              borderRadius: BorderRadius.circular(12),
                              border: Border.all(
                                color: AppColors.accent.withValues(alpha: 0.4),
                              ),
                            ),
                            child: Text(
                              controller.userRoleLabel.value,
                              style: const TextStyle(
                                color: AppColors.accentLight,
                                fontSize: 11,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Navigator.pop(context),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),

            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

            // ── Menu ──
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(12, 12, 12, 8),
                children: [
                  _DrawerSectionLabel('Explore'),
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.gavel_rounded,
                    label: 'My bids',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onViewAllBids();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.add_circle_outline_rounded,
                    label: 'Create bid',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onCreateBid();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.map_outlined,
                    label: 'Map view',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onMapView();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.favorite_border_rounded,
                    label: 'Saved hostels',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onSaved();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.apartment_rounded,
                    label: 'Hostels near you',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onSeeAllHostels();
                    },
                  ),

                  const SizedBox(height: 8),
                  _DrawerSectionLabel('Account'),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onProfile;
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Chat',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onChat();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.notifications_none_rounded,
                    label: 'Notifications',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onNotifications();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.settings_outlined,
                    label: 'Settings',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onSettings();
                    },
                  ),

                  const SizedBox(height: 12),
                  Divider(color: Colors.white.withValues(alpha: 0.08)),
                  const SizedBox(height: 4),

                  // Logout
                  _DrawerItem(
                    icon: Icons.logout_rounded,
                    label: 'Log out',
                    danger: true,
                    onTap: () {
                      Navigator.pop(context);
                      controller.onLogout();
                    },
                  ),
                ],
              ),
            ),

            // ── Footer ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
              child: Text(
                'Hostel Buddy v1.0.0',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.3),
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DrawerSectionLabel extends StatelessWidget {
  const _DrawerSectionLabel(this.label);
  final String label;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(12, 8, 12, 6),
      child: Text(
        label.toUpperCase(),
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.35),
          fontSize: 11,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.8,
        ),
      ),
    );
  }
}

class _DrawerItem extends StatelessWidget {
  const _DrawerItem({
    required this.icon,
    required this.label,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final color = danger ? AppColors.error : Colors.white;
    final iconColor = danger ? AppColors.error : AppColors.accentLight;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(14),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          child: Row(
            children: [
              Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: danger
                      ? AppColors.error.withValues(alpha: 0.12)
                      : AppColors.accent.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    color: color,
                    fontSize: 14.5,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              if (!danger)
                Icon(
                  Icons.chevron_right_rounded,
                  size: 18,
                  color: Colors.white.withValues(alpha: 0.25),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// SHARED
// ═══════════════════════════════════════════

class _GlassBox extends StatelessWidget {
  const _GlassBox({required this.child});
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: child,
        ),
      ),
    );
  }
}

class _Blob extends StatelessWidget {
  const _Blob({required this.size, required this.color});
  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
