import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navbar.dart';
import '../controllers/manager_home_controller.dart';

class ManagerHomeView extends GetView<ManagerHomeController> {
  const ManagerHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        key: controller.scaffoldKey,
        backgroundColor: AppColors.scaffoldBackground,
        endDrawer: _ManagerDrawer(controller: controller),
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: [
            SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding: const EdgeInsets.only(bottom: 110),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _Header(controller: controller),
                  Transform.translate(
                    offset: const Offset(0, -28),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        children: [
                          _StatsGlance(controller: controller),
                          const SizedBox(height: 12),
                          _OccupancyCard(controller: controller),
                          const SizedBox(height: 14),
                          _QuickActions(controller: controller),
                          const SizedBox(height: 22),
                          _BidsSection(controller: controller),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: Obx(
                () => AppBottomNavBar(
                  selectedIndex: controller.selectedNavIndex.value,
                  onTap: controller.onNavTap,
                  items: AppBottomNavBar.managerItems,
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
// HEADER
// ═══════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(20, top + 4, 20, 40),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(32)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: controller.onProfile,
                child: Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.15),
                    border: Border.all(
                      color: Colors.white.withValues(alpha: 0.25),
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
                  onTap: controller.onHostelDropdown,
                  child: Obx(() {
                    final _ = controller.selectedHostelIndex.value;
                    final __ = controller.hostels.length;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Flexible(
                              child: Text(
                                controller.hostelName,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            ),
                            Icon(
                              Icons.keyboard_arrow_down_rounded,
                              color: Colors.white.withValues(alpha: 0.7),
                              size: 18,
                            ),
                          ],
                        ),
                        Text(
                          controller.currentCity.value,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
              ),
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
                        color: Colors.white.withValues(alpha: 0.12),
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
                    color: Colors.white.withValues(alpha: 0.12),
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
          const SizedBox(height: 20),
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
                        color: Colors.white.withValues(alpha: 0.75),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Obx(
                      () => Text(
                        '${controller.userName.value}.',
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.6,
                          height: 1.15,
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.12),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.18),
                        ),
                      ),
                      child: const Text(
                        'Hostel manager',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 12,
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
                  color: Colors.white.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.16),
                  ),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 12,
                          color: Colors.white.withValues(alpha: 0.55),
                        ),
                        const SizedBox(width: 5),
                        Text(
                          "Today's Date",
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.55),
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
                        color: Colors.white.withValues(alpha: 0.6),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STATS
// ═══════════════════════════════════════════

class _StatsGlance extends StatelessWidget {
  const _StatsGlance({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Your hostel at a glance',
                  style: TextStyle(
                    color: AppColors.textPrimary,
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
                    color: AppColors.accent,
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
                    valueColor: AppColors.textPrimary,
                  ),
                ),
                _VDivider(),
                Expanded(
                  child: _StatCell(
                    value: '${controller.totalRooms.value}',
                    label: 'Rooms',
                    valueColor: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StatCell extends StatelessWidget {
  const _StatCell({
    required this.value,
    required this.label,
    this.valueColor,
  });

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
            color: valueColor ?? AppColors.textPrimary,
            fontSize: 26,
            fontWeight: FontWeight.w700,
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: AppColors.textSecondary,
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
    return Container(width: 1, height: 36, color: AppColors.divider);
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
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
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
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
                Text(
                  controller.occupancyLabel,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
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
                backgroundColor: AppColors.border,
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
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 12,
              ),
            ),
          ],
        );
      }),
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
            label: 'Edit hostel',
            icon: Icons.edit_outlined,
            filled: false,
            onTap: controller.onEditListing,
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
          color: filled ? AppColors.accent : Colors.white,
          border: filled ? null : Border.all(color: AppColors.border),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 14,
                    offset: const Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              color: filled ? Colors.white : AppColors.primary,
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: TextStyle(
                color: filled ? Colors.white : AppColors.textPrimary,
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
                  color: AppColors.textPrimary,
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
                  color: AppColors.accent,
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
                child: _BidCard(
                  bid: b,
                  onTap: () => controller.onBidTap(b),
                ),
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
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                name.isNotEmpty ? name[0].toUpperCase() : '?',
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w700,
                  fontSize: 18,
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
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: isPending
                    ? AppColors.warning.withValues(alpha: 0.12)
                    : AppColors.success.withValues(alpha: 0.12),
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
// DRAWER
// ═══════════════════════════════════════════

class _ManagerDrawer extends StatelessWidget {
  const _ManagerDrawer({required this.controller});
  final ManagerHomeController controller;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Drawer(
      backgroundColor: AppColors.scaffoldBackground,
      width: MediaQuery.of(context).size.width * 0.82,
      child: Column(
        children: [
          Container(
            width: double.infinity,
            padding: EdgeInsets.fromLTRB(20, top + 16, 12, 22),
            decoration: const BoxDecoration(
              color: AppColors.primary,
              borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
            ),
            child: Row(
              children: [
                Container(
                  width: 52,
                  height: 52,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white,
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    controller.initials,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontWeight: FontWeight.w800,
                      fontSize: 16,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Obx(() {
                    final _ = controller.selectedHostelIndex.value;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          controller.userName.value,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          controller.hostelName,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            color: Colors.white.withValues(alpha: 0.7),
                            fontSize: 12,
                          ),
                        ),
                      ],
                    );
                  }),
                ),
                IconButton(
                  onPressed: () => Get.back(),
                  icon: const Icon(Icons.close_rounded, color: Colors.white70),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 8),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: () {
                  Navigator.of(context).pop();
                  Future.microtask(() => controller.onSwitchHostel());
                },
                borderRadius: BorderRadius.circular(16),
                child: Ink(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    color: AppColors.accent.withValues(alpha: 0.1),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.4),
                    ),
                  ),
                  child: const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 14, vertical: 13),
                    child: Row(
                      children: [
                        Icon(Icons.swap_horiz_rounded,
                            color: AppColors.accent, size: 22),
                        SizedBox(width: 12),
                        Expanded(
                          child: Text(
                            'Switch hostel',
                            style: TextStyle(
                              color: AppColors.accent,
                              fontSize: 14.5,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios_rounded,
                            color: AppColors.accent, size: 14),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                _DrawerTile(
                  icon: Icons.gavel_rounded,
                  label: 'View bids',
                  onTap: () {
                    Get.back();
                    controller.onViewBids();
                  },
                ),
                _DrawerTile(
                  icon: Icons.meeting_room_outlined,
                  label: 'Rooms',
                  onTap: () {
                    Get.back();
                    controller.onManageRooms();
                  },
                ),
                _DrawerTile(
                  icon: Icons.edit_outlined,
                  label: 'Edit listing',
                  onTap: () {
                    Get.back();
                    controller.onEditListing();
                  },
                ),
                _DrawerTile(
                  icon: Icons.add_home_rounded,
                  label: 'Add listing',
                  onTap: () {
                    Get.back();
                    controller.onAddListing();
                  },
                ),
                _DrawerTile(
                  icon: Icons.person_outline_rounded,
                  label: 'Profile',
                  onTap: () {
                    Get.back();
                    controller.onProfile();
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.fromLTRB(
              16,
              8,
              16,
              16 + MediaQuery.of(context).padding.bottom,
            ),
            child: SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton.icon(
                onPressed: () {
                  Get.back();
                  controller.onLogout();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.error,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                icon: const Icon(Icons.logout_rounded, size: 18),
                label: const Text(
                  'Log out',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerTile extends StatelessWidget {
  const _DrawerTile({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(14),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
            child: Row(
              children: [
                Icon(icon, size: 22, color: AppColors.accent),
                const SizedBox(width: 14),
                Text(
                  label,
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}