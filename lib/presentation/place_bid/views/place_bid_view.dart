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
        backgroundColor: AppColors.scaffoldBackground,
        body: Column(
          children: [
            _Header(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 20),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const _SectionLabel('Hostel type'),
                    const SizedBox(height: 10),
                    _HostelTypeRow(controller: controller),
                    const SizedBox(height: 22),
                    const _SectionLabel('Room type'),
                    const SizedBox(height: 10),
                    _RoomTypeChips(controller: controller),
                    const SizedBox(height: 22),
                    Row(
                      children: [
                        const Expanded(
                          child: _SectionLabel('Amenities · pick any you need'),
                        ),
                        Obx(
                          () => GestureDetector(
                            onTap: controller.toggleSelectAllAmenities,
                            child: Text(
                              controller.allAmenitiesSelected
                                  ? 'Deselect all'
                                  : 'Select all',
                              style: const TextStyle(
                                color: AppColors.accent,
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    _AmenityChips(controller: controller),
                    const SizedBox(height: 22),
                    const _SectionLabel('Your offer'),
                    const SizedBox(height: 6),
                    Text(
                      'Minimum Rs ${controller.formatAmount(PlaceBidController.minBid)}',
                      style: const TextStyle(
                        color: AppColors.textMuted,
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _OfferBox(controller: controller),
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(
                20,
                8,
                20,
                16 + MediaQuery.of(context).padding.bottom,
              ),
              child: _PlaceBidButton(controller: controller),
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
              child: const Icon(Icons.arrow_back_ios_new_rounded,
                  color: Colors.white, size: 18),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Place a bid',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Set your offer & requirements',
                  style: TextStyle(color: Colors.white70, fontSize: 13),
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
      style: const TextStyle(
        color: AppColors.textSecondary,
        fontSize: 13,
        fontWeight: FontWeight.w600,
      ),
    );
  }
}

class _HostelTypeRow extends StatelessWidget {
  const _HostelTypeRow({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      return Row(
        children: [
          Expanded(
            child: _TypeCard(
              label: 'Boys Hostel',
              icon: Icons.male_rounded,
              selected: controller.selectedHostelType.value == 'Boys Hostel',
              onTap: () => controller.selectHostelType('Boys Hostel'),
            ),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: _TypeCard(
              label: 'Girls Hostel',
              icon: Icons.female_rounded,
              selected: controller.selectedHostelType.value == 'Girls Hostel',
              onTap: () => controller.selectHostelType('Girls Hostel'),
            ),
          ),
        ],
      );
    });
  }
}

class _TypeCard extends StatelessWidget {
  const _TypeCard({
    required this.label,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon,
                size: 20,
                color: selected ? AppColors.accent : AppColors.textMuted),
            const SizedBox(width: 8),
            Text(
              label,
              style: TextStyle(
                color: selected ? AppColors.accent : AppColors.textPrimary,
                fontSize: 13,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

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
                padding:
                    const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                decoration: BoxDecoration(
                  color: selected ? AppColors.primary : AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: selected ? AppColors.primary : AppColors.border,
                  ),
                ),
                child: Text(
                  s,
                  style: TextStyle(
                    color: selected ? Colors.white : AppColors.textPrimary,
                    fontSize: 13,
                    fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          }),
          GestureDetector(
            onTap: controller.openAddSeaterDialog,
            child: Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(22),
                border: Border.all(color: AppColors.border),
              ),
              child: const Center(
                child: Icon(Icons.add, color: AppColors.accent, size: 20),
              ),
            ),
          ),
        ],
      );
    });
  }
}

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
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
              decoration: BoxDecoration(
                color: selected
                    ? AppColors.accent.withValues(alpha: 0.12)
                    : AppColors.surfaceWhite,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: selected ? AppColors.accent : AppColors.border,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (selected) ...[
                    const Icon(Icons.check_rounded,
                        size: 14, color: AppColors.accent),
                    const SizedBox(width: 4),
                  ],
                  Text(
                    a,
                    style: TextStyle(
                      color:
                          selected ? AppColors.accent : AppColors.textPrimary,
                      fontSize: 13,
                      fontWeight:
                          selected ? FontWeight.w600 : FontWeight.w500,
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

class _OfferBox extends StatelessWidget {
  const _OfferBox({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 14),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Obx(
                () => _RoundBtn(
                  icon: Icons.remove_rounded,
                  enabled: controller.canDecrease,
                  onTap: controller.decreaseOffer,
                ),
              ),
              const SizedBox(width: 18),
              Obx(
                () => Text(
                  'Rs ${controller.formatAmount(controller.yourOffer.value)}',
                  style: const TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 28,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              const SizedBox(width: 18),
              _RoundBtn(
                icon: Icons.add_rounded,
                enabled: true,
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
  const _RoundBtn({
    required this.icon,
    required this.onTap,
    required this.enabled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool enabled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: enabled ? onTap : null,
      child: Opacity(
        opacity: enabled ? 1 : 0.35,
        child: Container(
          width: 40,
          height: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: AppColors.surfaceSoft,
            border: Border.all(color: AppColors.border),
          ),
          child: Icon(icon, color: AppColors.textPrimary, size: 20),
        ),
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
              ? AppColors.accent.withValues(alpha: 0.12)
              : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: highlight ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: highlight ? AppColors.accent : AppColors.textPrimary,
            fontSize: 12,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

class _PlaceBidButton extends StatelessWidget {
  const _PlaceBidButton({required this.controller});
  final PlaceBidController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final ok = controller.canPlaceBid;
      return SizedBox(
        width: double.infinity,
        height: 54,
        child: ElevatedButton(
          onPressed: ok ? controller.placeBid : null,
          style: ElevatedButton.styleFrom(
            backgroundColor: ok ? AppColors.accent : AppColors.border,
            foregroundColor: Colors.white,
            disabledBackgroundColor: AppColors.border,
            disabledForegroundColor: AppColors.textMuted,
            elevation: 0,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(28),
            ),
          ),
          child: Text(
            'Place bid · Rs ${controller.formatAmount(controller.yourOffer.value)}',
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w700),
          ),
        ),
      );
    });
  }
}