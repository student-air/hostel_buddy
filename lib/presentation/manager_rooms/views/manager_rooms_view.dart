import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navbar.dart';
import '../controllers/manager_rooms_controller.dart';

class ManagerRoomsView extends GetView<ManagerRoomsController> {
  const ManagerRoomsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        floatingActionButton: Padding(
          padding: const EdgeInsets.only(bottom: 72),
          child: FloatingActionButton.extended(
            onPressed: controller.onAddRoom,
            backgroundColor: AppColors.accent,
            foregroundColor: Colors.white,
            elevation: 2,
            icon: const Icon(Icons.add_rounded),
            label: const Text(
              'Add room',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ),
        ),
        body: Stack(
          children: [
            Column(
              children: [
                _Header(controller: controller),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      _StatsRow(controller: controller),
                      const SizedBox(height: 12),
                      _SearchBar(controller: controller),
                      const SizedBox(height: 12),
                      _Filters(controller: controller),
                      const SizedBox(height: 8),
                      Expanded(child: _Body(controller: controller)),
                    ],
                  ),
                ),
              ],
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

class _Header extends StatelessWidget {
  const _Header({required this.controller});
  final ManagerRoomsController controller;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 8, 20, 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.offAllNamed('/manager-home'),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Rooms',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Manage capacity & occupancy',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
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

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.controller});
  final ManagerRoomsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(
        () => Row(
          children: [
            _StatPill(
              label: 'Total',
              value: '${controller.totalCount}',
              color: AppColors.primary,
            ),
            const SizedBox(width: 8),
            _StatPill(
              label: 'Vacant',
              value: '${controller.vacantCount}',
              color: AppColors.success,
            ),
            const SizedBox(width: 8),
            _StatPill(
              label: 'Occupied',
              value: '${controller.occupiedCount}',
              color: AppColors.warning,
            ),
            const SizedBox(width: 8),
            _StatPill(
              label: 'Reserved',
              value: '${controller.reservedCount}',
              color: AppColors.accent,
            ),
          ],
        ),
      ),
    );
  }
}

class _StatPill extends StatelessWidget {
  const _StatPill({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: AppColors.border),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: TextStyle(
                color: color,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final ManagerRoomsController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
        ),
        child: TextField(
          onChanged: controller.onSearchChanged,
          style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
          cursorColor: AppColors.primary,
          decoration: const InputDecoration(
            hintText: 'Search room number…',
            hintStyle: TextStyle(color: AppColors.textMuted, fontSize: 15),
            prefixIcon: Icon(Icons.search_rounded, color: AppColors.accent),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller});
  final ManagerRoomsController controller;

  @override
  Widget build(BuildContext context) {
    const labels = ['All', 'Vacant', 'Occupied', 'Reserved'];
    return SizedBox(
      height: 40,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: labels.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          return Obx(() {
            final sel = controller.selectedFilter.value == i;
            return GestureDetector(
              onTap: () => controller.onFilterChanged(i),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: sel ? AppColors.primary : Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                    color: sel ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  labels[i],
                  style: TextStyle(
                    color: sel ? Colors.white : AppColors.textSecondary,
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final ManagerRoomsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filtered;
      if (list.isEmpty) {
        return const Center(
          child: Text(
            'No rooms found',
            style: TextStyle(color: AppColors.textSecondary, fontSize: 15),
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 140),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 10),
        itemBuilder: (_, i) => _RoomCard(
          room: list[i],
          onTap: () => controller.onRoomTap(list[i]),
          onDelete: () => controller.onDeleteRoom(list[i]),
        ),
      );
    });
  }
}

class _RoomCard extends StatelessWidget {
  const _RoomCard({
    required this.room,
    required this.onTap,
    required this.onDelete,
  });

  final HostelRoom room;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  Color get statusColor {
    switch (room.status) {
      case 'vacant':
        return AppColors.success;
      case 'occupied':
        return AppColors.warning;
      case 'reserved':
        return AppColors.accent;
      default:
        return AppColors.textMuted;
    }
  }

  String get statusLabel =>
      room.status[0].toUpperCase() + room.status.substring(1);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 52,
              height: 52,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14),
                color: AppColors.primary.withValues(alpha: 0.1),
              ),
              alignment: Alignment.center,
              child: Text(
                room.number,
                style: const TextStyle(
                  color: AppColors.primary,
                  fontWeight: FontWeight.w800,
                  fontSize: 15,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Room ${room.number}',
                    style: const TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    '${room.seater} · Floor ${room.floor}',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    room.rent,
                    style: const TextStyle(
                      color: AppColors.primary,
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: statusColor.withValues(alpha: 0.12),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    statusLabel,
                    style: TextStyle(
                      color: statusColor,
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 20,
                    color: AppColors.error,
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