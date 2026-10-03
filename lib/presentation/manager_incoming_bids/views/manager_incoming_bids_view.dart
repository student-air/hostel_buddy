import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/widgets/bottom_navbar.dart';
import '../controllers/manager_incoming_bids_controller.dart';

class ManagerIncomingBidsView extends GetView<ManagerIncomingBidsController> {
  const ManagerIncomingBidsView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          children: [
            Column(
              children: [
                _Header(),
                Expanded(
                  child: Column(
                    children: [
                      const SizedBox(height: 14),
                      _SearchBar(controller: controller),
                      const SizedBox(height: 12),
                      _Tabs(controller: controller),
                      const SizedBox(height: 12),
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
            onTap: () => Get.back(),
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
                  'Incoming Bids',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Respond to seeker offers',
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

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final ManagerIncomingBidsController controller;

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
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: TextField(
          onChanged: controller.onSearchChanged,
          style: const TextStyle(
            color: AppColors.textPrimary,
            fontSize: 15,
          ),
          cursorColor: AppColors.primary,
          decoration: const InputDecoration(
            hintText: 'Search bids...',
            hintStyle: TextStyle(
              color: AppColors.textMuted,
              fontSize: 15,
            ),
            prefixIcon: Icon(
              Icons.search_rounded,
              color: AppColors.accent,
              size: 22,
            ),
            border: InputBorder.none,
            contentPadding: EdgeInsets.symmetric(vertical: 14),
          ),
        ),
      ),
    );
  }
}

class _Tabs extends StatelessWidget {
  const _Tabs({required this.controller});
  final ManagerIncomingBidsController controller;

  @override
  Widget build(BuildContext context) {
    const labels = ['All', 'Offered', 'Accepted'];
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Obx(() {
        final selected = controller.selectedTab.value;
        return Container(
          height: 44,
          padding: const EdgeInsets.all(4),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Row(
            children: List.generate(labels.length, (i) {
              final sel = selected == i;
              return Expanded(
                child: GestureDetector(
                  onTap: () => controller.onTabChanged(i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: sel ? AppColors.primary : Colors.transparent,
                      borderRadius: BorderRadius.circular(18),
                      boxShadow: sel
                          ? [
                              BoxShadow(
                                color:
                                    AppColors.primary.withValues(alpha: 0.25),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ]
                          : null,
                    ),
                    child: Text(
                      labels[i],
                      style: TextStyle(
                        color: sel ? Colors.white : AppColors.textSecondary,
                        fontSize: 13,
                        fontWeight: sel ? FontWeight.w700 : FontWeight.w500,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        );
      }),
    );
  }
}

class _Body extends StatelessWidget {
  const _Body({required this.controller});
  final ManagerIncomingBidsController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final list = controller.filtered;
      if (list.isEmpty) {
        return Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                width: 72,
                height: 72,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(alpha: 0.08),
                ),
                child: const Icon(
                  Icons.gavel_rounded,
                  size: 36,
                  color: AppColors.primary,
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'No bids here',
                style: TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        );
      }
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 4, 20, 110),
        physics: const BouncingScrollPhysics(),
        itemCount: list.length,
        separatorBuilder: (_, __) => const SizedBox(height: 12),
        itemBuilder: (_, i) => _BidCard(
          bid: list[i],
          onAccept: () => controller.onAcceptTap(list[i]),
          onReject: () => controller.rejectBid(list[i]),
        ),
      );
    });
  }
}

class _BidCard extends StatelessWidget {
  const _BidCard({
    required this.bid,
    required this.onAccept,
    required this.onReject,
  });

  final IncomingBid bid;
  final VoidCallback onAccept;
  final VoidCallback onReject;

  Color get statusColor {
    switch (bid.status) {
      case 'pending':
        return AppColors.warning;
      case 'offered':
        return AppColors.accent;
      case 'accepted':
        return AppColors.success;
      default:
        return AppColors.textMuted;
    }
  }

  String get statusLabel {
    switch (bid.status) {
      case 'pending':
        return 'Pending';
      case 'offered':
        return 'Offered';
      case 'accepted':
        return 'Accepted';
      default:
        return bid.status;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isPending = bid.status == 'pending';

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.05),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14),
                  color: AppColors.primary,
                ),
                alignment: Alignment.center,
                child: Text(
                  bid.initials,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
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
                      bid.seekerName,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      '${bid.seater} · ${bid.time}',
                      style: const TextStyle(
                        color: AppColors.textSecondary,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                decoration: BoxDecoration(
                  color: statusColor.withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(20),
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
            ],
          ),
          const SizedBox(height: 12),
          Text(
            bid.offer,
            style: const TextStyle(
              color: AppColors.primary,
              fontSize: 16,
              fontWeight: FontWeight.w800,
            ),
          ),
          if (bid.managerOffer != null &&
              bid.managerOffer != bid.offer) ...[
            const SizedBox(height: 4),
            Text(
              'Your offer: ${bid.managerOffer}',
              style: const TextStyle(
                color: AppColors.accent,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
          if (bid.amenities.isNotEmpty) ...[
            const SizedBox(height: 10),
            Wrap(
              spacing: 6,
              runSpacing: 6,
              children: bid.amenities.map((a) {
                return Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  decoration: BoxDecoration(
                    color: AppColors.tagBackground,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    a,
                    style: const TextStyle(
                      color: AppColors.tagText,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              }).toList(),
            ),
          ],
          if (isPending) ...[
            const SizedBox(height: 14),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: OutlinedButton(
                      onPressed: onReject,
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.error,
                        side: const BorderSide(color: AppColors.error),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Reject',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: SizedBox(
                    height: 42,
                    child: ElevatedButton(
                      onPressed: onAccept,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.success,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(22),
                        ),
                      ),
                      child: const Text(
                        'Accept',
                        style: TextStyle(fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}