import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/place_bid_controller.dart';

class PlaceBidView extends GetView<PlaceBidController> {
  const PlaceBidView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Same background as Home
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
  child: Column(
    children: [
      const SizedBox(height: 8),
      _AppealingHeader(),
      Expanded(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                          _SectionLabel('Room type'),
                          const SizedBox(height: 10),
                          _RoomTypeChips(controller: controller),
                          const SizedBox(height: 22),
                          _SectionLabel('Amenities · pick any you need'),
                          const SizedBox(height: 10),
                          _AmenityChips(controller: controller),
                          const SizedBox(height: 22),
                          _HighestBidCard(controller: controller),
                          const SizedBox(height: 22),
                          _SectionLabel('Your offer'),
                          const SizedBox(height: 10),
                          _OfferBox(controller: controller),
                          const SizedBox(height: 14),
                          _StatusLine(controller: controller),
                        ],
                      ),
                    ),
                  ),
                  Padding(
        padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
        child: _PlaceBidButton(controller: controller),
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

// ═══════════════════════════════════════════
// HEADER (same style as Bids / Search)
// ══════════════════════════════════════════

class _AppealingHeader extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.1),
                border: Border.all(color: Colors.white.withValues(alpha: 0.14)),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Place a bid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Set your offer & requirements',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.45),
              ),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.gavel_rounded, size: 14, color: AppColors.accentLight),
                SizedBox(width: 5),
                Text(
                  'New bid',
                  style: TextStyle(
                    color: AppColors.accentLight,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel(this.text);
  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        color: Colors.white.withValues(alpha: 0.7),
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

// ═══════════════════════════════════════════
// ROOM TYPE
// ═══════════════════════════════════════════

class _RoomTypeChips extends StatelessWidget {
  const _RoomTypeChips({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          ...controller.seaters.map((s) {
            final selected = controller.selectedSeater.value == s;
            return GestureDetector(
              onTap: () => controller.selectSeater(s),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.accent : Colors.transparent,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected
                        ? AppColors.accent
                        : Colors.white.withValues(alpha: 0.2),
                  ),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : Colors.white.withValues(alpha: 0.75),
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
          // Dashed + → opens add dialog
          GestureDetector(
            onTap: controller.openAddSeaterDialog,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(22),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1.2,
                ),
              ),
              child: const Center(
                child: Icon(Icons.add, color: Colors.white54, size: 20),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════
// AMENITIES
// ═══════════════════════════════════════════

class _AmenityChips extends StatelessWidget {
  const _AmenityChips({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Wrap(
        spacing: 8,
        runSpacing: 8,
        children: controller.amenities.map((a) {
          final selected = controller.selectedAmenities.contains(a);
          return GestureDetector(
            onTap: () => controller.toggleAmenity(a),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accent.withValues(alpha: 0.2)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected
                      ? AppColors.accent
                      : Colors.white.withValues(alpha: 0.2),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    const Icon(
                      Icons.check_rounded,
                      size: 14,
                      color: AppColors.accentLight,
                    ),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    a,
                    style: TextStyle(
                      color: selected
                          ? AppColors.accentLight
                          : Colors.white.withValues(alpha: 0.7),
                      fontSize: 13,
                      fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          );
        }).toList(),
      );
    });
  }
}

// ═══════════════════════════════════════════
// HIGHEST BID
// ═══════════════════════════════════════════

class _HighestBidCard extends StatelessWidget {
  const _HighestBidCard({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.1)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFE0A33C).withValues(alpha: 0.2),
            ),
            child: const Icon(
              Icons.emoji_events_rounded,
              color: Color(0xFFE0A33C),
              size: 22,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Current highest bid',
                  style: TextStyle(
                    color: Colors.white.withValues(alpha: 0.55),
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 2),
                Obx(
                  () => Text(
                    'Rs ${controller.formatAmount(controller.currentHighestBid.value)}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Obx(
            () => Text(
              '${controller.bidsSoFar.value} bids so far',
              style: TextStyle(
                color: Colors.white.withValues(alpha: 0.5),
                fontSize: 12,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// YOUR OFFER
// ═══════════════════════════════════════════

class _OfferBox extends StatelessWidget {
  const _OfferBox({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.06),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundBtn(
                icon: Icons.remove_rounded,
                onTap: controller.decreaseOffer,
              ),
              const SizedBox(width: 18),
              Obx(
                () => Text(
                  'Rs ${controller.formatAmount(controller.yourOffer.value)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.6,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              _RoundBtn(
                icon: Icons.add_rounded,
                onTap: controller.increaseOffer,
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            children: [
              Expanded(
                child: _QuickAdd(
                  label: '+ Rs 500',
                  onTap: () => controller.addAmount(500),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAdd(
                  label: '+ Rs 1,000',
                  onTap: () => controller.addAmount(1000),
                  highlight: true,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _QuickAdd(
                  label: '+ Rs 2,000',
                  onTap: () => controller.addAmount(2000),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _RoundBtn extends StatelessWidget {
  const _RoundBtn({required this.icon, required this.onTap});
  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.1),
          border: Border.all(color: Colors.white.withValues(alpha: 0.15)),
        ),
        child: Icon(icon, color: Colors.white, size: 20),
      ),
    );
  }
}

class _QuickAdd extends StatelessWidget {
  const _QuickAdd({
    required this.label,
    required this.onTap,
    this.highlight = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool highlight;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: highlight
              ? AppColors.accent.withValues(alpha: 0.2)
              : Colors.white.withValues(alpha: 0.06),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlight
                ? AppColors.accent.withValues(alpha: 0.5)
                : Colors.white.withValues(alpha: 0.12),
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: highlight
                ? AppColors.accentLight
                : Colors.white.withValues(alpha: 0.8),
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STATUS + BUTTON
// ═══════════════════════════════════════════

class _StatusLine extends StatelessWidget {
  const _StatusLine({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ok = controller.isHighest;
      return Row(
        children: [
          Icon(
            ok ? Icons.check_circle_rounded : Icons.warning_amber_rounded,
            size: 18,
            color: ok ? AppColors.success : AppColors.error,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              ok
                  ? "You'd be the highest bid"
                  : 'Bid must be higher than Rs ${controller.formatAmount(controller.currentHighestBid.value)}',
              style: TextStyle(
                color: ok ? AppColors.success : AppColors.error,
                fontSize: 13,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ],
      );
    });
  }
}

class _PlaceBidButton extends StatelessWidget {
  const _PlaceBidButton({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ok = controller.isHighest;
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: ok ? controller.placeBid : null,
          style: ElevatedButton.styleFrom(
            backgroundColor:
                ok ? AppColors.accent : Colors.white.withValues(alpha: 0.12),
            foregroundColor: Colors.white,
            disabledBackgroundColor: Colors.white.withValues(alpha: 0.1),
            disabledForegroundColor: Colors.white.withValues(alpha: 0.35),
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(20),
            ),
          ),
          child: Text(
            ok
                ? 'Place bid · Rs ${controller.formatAmount(controller.yourOffer.value)}'
                : 'Place bid',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
    });
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