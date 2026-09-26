import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/manager_home_controller.dart';

class ManagerHomeView extends GetView<ManagerHomeController> {
  const ManagerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: controller.scaffoldKey,
        endDrawer: _ManagerDrawer(controller: controller),
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
                          _StatsGlance(controller: controller),
                          const SizedBox(height: 18),
                          _OccupancyCard(controller: controller),
                          const SizedBox(height: 18),
                          _QuickActions(controller: controller),
                          const SizedBox(height: 26),
                          _BidsSection(controller: controller),
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
// HEADER (matches seeker: greeting + date card)
// ═══════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Top: initials → profile | hostel name | bell | menu
        Row(
          children: [
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      controller.hostelName.value,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    Text(
                      controller.currentCity.value,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.5),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Notification
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
            // Menu → drawer
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
          ],
        ),
        const SizedBox(height: 22),

        // Greeting + date card (same as seeker)
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
                    child: const Text(
                      'Hostel manager',
                      style: TextStyle(
                        color: AppColors.accentLight,
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
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
// STATS GLANCE (glass — same as seeker bids glance)
// ═══════════════════════════════════════════

class _StatsGlance extends StatelessWidget {
  const _StatsGlance({required this.controller});
  final ManagerHomeController controller;

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
                      'Your hostel at a glance',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: controller.onViewBids,
                    child: const Text(
                      'View bids',
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
                        value: controller.monthlyRevenue.value,
                        label: 'This month',
                        valueColor: AppColors.success,
                      ),
                    ),
                    _VDivider(),
                    Expanded(
                      child: _StatCell(
                        value: '${controller.totalRooms.value}',
                        label: 'Rooms',
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
// OCCUPANCY
// ═══════════════════════════════════════════

class _OccupancyCard extends StatelessWidget {
  const _OccupancyCard({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(18),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            color: Colors.white.withValues(alpha: 0.08),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Obx(() {
            final rate = controller.occupancyRate;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    const Expanded(
                      child: Text(
                        'Occupancy',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      controller.occupancyLabel,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: LinearProgressIndicator(
                    value: rate,
                    minHeight: 8,
                    backgroundColor: Colors.white.withValues(alpha: 0.12),
                    valueColor: AlwaysStoppedAnimation<Color>(
                      rate >= 0.85
                          ? AppColors.success
                          : rate >= 0.5
                          ? AppColors.accent
                          : AppColors.warning,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  '${(rate * 100).round()}% filled',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.5),
                    fontSize: 12,
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// QUICK ACTIONS
// ═══════════════════════════════════════════

class _QuickActions extends StatelessWidget {
  const _QuickActions({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionTile(
            label: 'View bids',
            icon: Icons.gavel_rounded,
            filled: true,
            onTap: controller.onViewBids,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            label: 'Rooms',
            icon: Icons.meeting_room_outlined,
            filled: false,
            onTap: controller.onManageRooms,
          ),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: _ActionTile(
            label: 'Messages',
            icon: Icons.chat_bubble_outline_rounded,
            filled: false,
            onTap: controller.onMessages,
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
// RECENT BIDS
// ═══════════════════════════════════════════

class _BidsSection extends StatelessWidget {
  const _BidsSection({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Recent bids',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            GestureDetector(
              onTap: controller.onViewBids,
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
            children: controller.recentBids.map((b) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 12),
                child: _BidCard(bid: b, onTap: () => controller.onBidTap(b)),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }
}

class _BidCard extends StatelessWidget {
  const _BidCard({required this.bid, required this.onTap});
  final Map<String, dynamic> bid;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final status = bid['status']?.toString() ?? '';
    final isPending = status == 'Pending';
    final name = bid['name']?.toString() ?? '?';

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
                color: AppColors.primary.withValues(alpha: 0.12),
              ),
              alignment: Alignment.center,
              child: Text(
                name[0].toUpperCase(),
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 20,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    name,
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${bid['room']} · ${bid['time']}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    bid['offer']?.toString() ?? '',
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isPending
                    ? AppColors.warning.withValues(alpha: 0.15)
                    : AppColors.success.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: isPending ? AppColors.warning : AppColors.success,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
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

  final ManagerHomeController controller;
  final double bottomPad;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.gavel_rounded, 'Bids'),
    (Icons.meeting_room_outlined, 'Rooms'),
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
// DRAWER
// ═══════════════════════════════════════════

class _ManagerDrawer extends StatelessWidget {
  const _ManagerDrawer({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      backgroundColor: const Color(0xFF1F030E),
      child: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.accent.withValues(alpha: 0.25),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.5),
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
                          fontSize: 16,
                        ),
                      );
                    }),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Obx(
                          () => Text(
                            controller.userName.value,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 17,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Obx(
                          () => Text(
                            controller.hostelName.value,
                            style: TextStyle(
                              color: Colors.white.withValues(alpha: 0.5),
                              fontSize: 12,
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
                      color: Colors.white.withValues(alpha: 0.7),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 24),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                children: [
                  _DrawerItem(
                    icon: Icons.home_rounded,
                    label: 'Home',
                    onTap: () => Navigator.pop(context),
                  ),
                  _DrawerItem(
                    icon: Icons.gavel_rounded,
                    label: 'Bids',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onViewBids();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.meeting_room_outlined,
                    label: 'Manage rooms',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onManageRooms();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.edit_outlined,
                    label: 'Edit listing',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onEditListing();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.add_home_outlined,
                    label: 'Add hostel',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onAddListing();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.chat_bubble_outline_rounded,
                    label: 'Messages',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onMessages();
                    },
                  ),
                  _DrawerItem(
                    icon: Icons.person_outline_rounded,
                    label: 'Profile',
                    onTap: () {
                      Navigator.pop(context);
                      controller.onProfile();
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
                  Divider(
                    color: Colors.white.withValues(alpha: 0.08),
                    height: 28,
                  ),
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
          ],
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
    final color = danger
        ? AppColors.error
        : Colors.white.withValues(alpha: 0.88);

    return ListTile(
      onTap: onTap,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      leading: Icon(icon, color: color, size: 22),
      title: Text(
        label,
        style: TextStyle(
          color: color,
          fontSize: 14.5,
          fontWeight: FontWeight.w600,
        ),
      ),
      dense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
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
