import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/validators.dart';
import '../controllers/hostel_setup_controller.dart';

class HostelSetupView extends GetView<HostelSetupController> {
  const HostelSetupView({super.key});

  static const _stepTitles = [
    'Hostel basics',
    'Rooms & capacity',
    'Facilities & amenities',
  ];
  static const _stepSubtitles = [
    'Name, location and a few photos',
    'How many rooms, and what kind',
    "Who it's for, and what's included",
  ];

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Column(
          children: [
            Obx(
              () => _Header(
                step: controller.currentStep.value,
                progress: (controller.currentStep.value + 1) / 3,
                stepLabel: '${controller.currentStep.value + 1}/3',
                title: _stepTitles[controller.currentStep.value],
                subtitle: _stepSubtitles[controller.currentStep.value],
                onBack: controller.previousStep,
              ),
            ),
            Expanded(
              child: PageView(
                controller: controller.pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (i) => controller.currentStep.value = i,
                children: [
                  _StepBasics(controller: controller),
                  _StepRooms(controller: controller),
                  _StepFacilities(controller: controller),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(24, 8, 24, 12 + bottomPad),
              child: Obx(() {
                final isLast = controller.currentStep.value == 2;
                return _TealButton(
                  label: isLast ? 'Publish listing' : 'Continue',
                  isLoading: controller.isLoading.value,
                  onTap: isLast
                      ? controller.publishListing
                      : controller.nextStep,
                );
              }),
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
  const _Header({
    required this.step,
    required this.progress,
    required this.stepLabel,
    required this.title,
    required this.subtitle,
    required this.onBack,
  });

  final int step;
  final double progress;
  final String stepLabel;
  final String title;
  final String subtitle;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 6, 20, 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              GestureDetector(
                onTap: onBack,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.white.withValues(alpha: 0.12),
                  ),
                  child: const Icon(
                    Icons.arrow_back_ios_new_rounded,
                    size: 16,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(4),
                  child: LinearProgressIndicator(
                    value: progress,
                    minHeight: 5,
                    backgroundColor: Colors.white.withValues(alpha: 0.2),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                      AppColors.accent,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Text(
                stepLabel,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white.withValues(alpha: 0.75),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: TextStyle(
              color: Colors.white.withValues(alpha: 0.7),
              fontSize: 13,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STEP 1 — Basics
// ═══════════════════════════════════════════

class _StepBasics extends StatelessWidget {
  const _StepBasics({required this.controller});
  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: controller.basicsFormKey,
      child: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
        physics: const BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => Text(
                'Pictures (${controller.photoPaths.length}/${AppConstants.maxHostelPhotos})',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                ),
              ),
            ),
            const SizedBox(height: 12),
            _PhotoPickerSection(controller: controller),
            const SizedBox(height: 20),
            _LightField(
              controller: controller.nameController,
              label: 'Hostel name',
              hint: 'Green Valley Hostel',
              validator: Validators.hostelName,
              prefixIcon: Icons.home_outlined,
              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 14),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _LightField(
                    controller: controller.areaController,
                    label: 'Area',
                    hint: 'G-9',
                    validator: (v) =>
                        Validators.required(v, fieldName: 'Area'),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Padding(
                        padding: EdgeInsets.only(left: 2, bottom: 8),
                        child: Text(
                          'City',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      ),
                      Obx(() {
                        final city = controller.selectedCity.value;
                        return GestureDetector(
                          onTap: controller.openCityPicker,
                          child: Container(
                            height: 52,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(28),
                              border: Border.all(color: AppColors.border),
                            ),
                            child: Row(
                              children: [
                                const Icon(
                                  Icons.location_on_outlined,
                                  size: 20,
                                  color: AppColors.accent,
                                ),
                                const SizedBox(width: 10),
                                Expanded(
                                  child: Text(
                                    city.isEmpty ? 'Select city' : city,
                                    overflow: TextOverflow.ellipsis,
                                    style: TextStyle(
                                      color: city.isEmpty
                                          ? AppColors.textMuted
                                          : AppColors.textPrimary,
                                      fontSize: 15,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                                const Icon(
                                  Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.textMuted,
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),
            _LightField(
              controller: controller.contactController,
              label: 'Contact number',
              hint: '+92 51 1234567',
              validator: Validators.phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 14),
            _LightField(
              controller: controller.descriptionController,
              label: 'Description',
              hint:
                  'Shared rooms 5 minutes from campus, common study hall, laundry twice a week…',
              maxLines: 4,
              textCapitalization: TextCapitalization.sentences,
            ),
          ],
        ),
      ),
    );
  }
}

class _PhotoPickerSection extends StatelessWidget {
  const _PhotoPickerSection({required this.controller});
  final HostelSetupController controller;

  static const _placeholderColors = [
    Color(0xFF8B3A55),
    Color(0xFF14B8A6),
  ];

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final paths = controller.photoPaths;
      final canAdd = paths.length < AppConstants.maxHostelPhotos;

      return SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        child: Row(
          children: [
            if (paths.isEmpty) ...[
              for (final c in _placeholderColors)
                Padding(
                  padding: const EdgeInsets.only(right: 10),
                  child: Container(
                    width: 72,
                    height: 72,
                    decoration: BoxDecoration(
                      color: c,
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                ),
            ],
            ...List.generate(paths.length, (i) {
              return Padding(
                padding: const EdgeInsets.only(right: 10),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 72,
                      height: 72,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16),
                        image: DecorationImage(
                          image: FileImage(File(paths[i])),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    Positioned(
                      top: -6,
                      right: -6,
                      child: GestureDetector(
                        onTap: () => controller.removePhoto(i),
                        child: Container(
                          width: 22,
                          height: 22,
                          decoration: const BoxDecoration(
                            color: AppColors.error,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.close_rounded,
                            size: 14,
                            color: Colors.white,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }),
            if (canAdd)
              GestureDetector(
                onTap: controller.pickPhotos,
                child: Container(
                  width: 72,
                  height: 72,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceWhite,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: AppColors.primary.withValues(alpha: 0.35),
                      width: 1.5,
                      strokeAlign: BorderSide.strokeAlignInside,
                    ),
                  ),
                  child: CustomPaint(
                    painter: _DashedBorderPainter(
                      color: AppColors.primary.withValues(alpha: 0.4),
                      radius: 16,
                    ),
                    child: const Center(
                      child: Icon(
                        Icons.add_rounded,
                        size: 28,
                        color: AppColors.primary,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      );
    });
  }
}

class _DashedBorderPainter extends CustomPainter {
  _DashedBorderPainter({required this.color, required this.radius});
  final Color color;
  final double radius;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;
    final rrect = RRect.fromRectAndRadius(
      Rect.fromLTWH(1, 1, size.width - 2, size.height - 2),
      Radius.circular(radius),
    );
    final path = Path()..addRRect(rrect);
    const dashWidth = 5.0;
    const dashSpace = 4.0;
    for (final metric in path.computeMetrics()) {
      var distance = 0.0;
      while (distance < metric.length) {
        final next = distance + dashWidth;
        canvas.drawPath(
          metric.extractPath(distance, next.clamp(0, metric.length)),
          paint,
        );
        distance = next + dashSpace;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

// ═══════════════════════════════════════════
// STEP 2 — Rooms
// ═══════════════════════════════════════════

class _StepRooms extends StatelessWidget {
  const _StepRooms({required this.controller});
  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 24, 24, 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Center(
            child: Text(
              'Total rooms',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundIconButton(
                icon: Icons.remove_rounded,
                onTap: controller.decrementRooms,
                filled: false,
              ),
              const SizedBox(width: 20),
              SizedBox(
                width: 100,
                child: TextField(
                  controller: controller.roomsTextController,
                  keyboardType: TextInputType.number,
                  textAlign: TextAlign.center,
                  inputFormatters: [
                    FilteringTextInputFormatter.digitsOnly,
                    LengthLimitingTextInputFormatter(3),
                  ],
                  onChanged: controller.onRoomsTextChanged,
                  style: const TextStyle(
                    fontSize: 44,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                    letterSpacing: -1,
                  ),
                  cursorColor: AppColors.primary,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    isDense: true,
                    contentPadding: EdgeInsets.zero,
                  ),
                ),
              ),
              const SizedBox(width: 20),
              _RoundIconButton(
                icon: Icons.add_rounded,
                onTap: controller.incrementRooms,
                filled: true,
              ),
            ],
          ),
          const SizedBox(height: 8),
          const Center(
            child: Text(
              'Tap the number to type',
              style: TextStyle(fontSize: 12, color: AppColors.textMuted),
            ),
          ),
          const SizedBox(height: 28),
          const Text(
            'Room type — select all that apply',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 14),
          Obx(() {
            final defaults = HostelSetupController.roomTypeOptions;
            final selected = controller.selectedRoomTypes;
            final custom =
                selected.where((t) => !defaults.contains(t)).toList();

            return Wrap(
              spacing: 10,
              runSpacing: 10,
              children: [
                ...defaults.map((type) {
                  final isSelected = selected.contains(type);
                  return _SelectChip(
                    label: type,
                    selected: isSelected,
                    onTap: () => controller.toggleRoomType(type),
                  );
                }),
                ...custom.map((type) {
                  return _SelectChip(
                    label: type,
                    selected: true,
                    onTap: () => controller.toggleRoomType(type),
                  );
                }),
              ],
            );
          }),
          const SizedBox(height: 18),
          GestureDetector(
            onTap: () => _showCustomSeaterSheet(context),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                border: Border.all(
                  color: AppColors.primary.withValues(alpha: 0.35),
                ),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.add_rounded, size: 18, color: AppColors.primary),
                  SizedBox(width: 6),
                  Text(
                    'Add custom seater',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: AppColors.primary,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomSeaterSheet(BuildContext context) {
    controller.customRoomTypeController.clear();
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Custom seater',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.customRoomTypeController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              cursorColor: AppColors.primary,
              textCapitalization: TextCapitalization.words,
              decoration: InputDecoration(
                hintText: 'e.g. 2-seater, 6-seater, Studio',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (_) {
                controller.addCustomRoomType();
                Get.back();
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  controller.addCustomRoomType();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({
    required this.icon,
    required this.onTap,
    required this.filled,
  });

  final IconData icon;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: filled ? AppColors.accent : Colors.white,
          border: filled ? null : Border.all(color: AppColors.border),
          boxShadow: filled
              ? [
                  BoxShadow(
                    color: AppColors.accent.withValues(alpha: 0.3),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ]
              : null,
        ),
        child: Icon(
          icon,
          color: filled ? Colors.white : AppColors.textPrimary,
          size: 22,
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STEP 3 — Facilities
// ═══════════════════════════════════════════

class _StepFacilities extends StatelessWidget {
  const _StepFacilities({required this.controller});
  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(24, 20, 24, 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Hostel type',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: 12),
          Obx(
            () => _HostelTypeSelector(
              selected: controller.selectedHostelType.value,
              onSelect: controller.selectHostelType,
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              const Expanded(
                child: Text(
                  'Amenities',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              Obx(() {
                final allSelected = controller.allFacilitiesSelected;
                return GestureDetector(
                  onTap: controller.toggleSelectAllFacilities,
                  child: Text(
                    allSelected ? 'Deselect all' : 'Select all',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.tagText,
                    ),
                  ),
                );
              }),
            ],
          ),
          const SizedBox(height: 12),
          Obx(() {
            final items = HostelSetupController.facilityOptions;
            return Column(
              children: [
                for (int i = 0; i < items.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i + 2 < items.length ? 12 : 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _FacilityChip(
                            label: items[i]['label'] as String,
                            icon: items[i]['icon'] as IconData,
                            selected: controller.selectedFacilities
                                .contains(items[i]['label']),
                            onTap: () => controller.toggleFacility(
                              items[i]['label'] as String,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: i + 1 < items.length
                              ? _FacilityChip(
                                  label: items[i + 1]['label'] as String,
                                  icon: items[i + 1]['icon'] as IconData,
                                  selected: controller.selectedFacilities
                                      .contains(items[i + 1]['label']),
                                  onTap: () => controller.toggleFacility(
                                    items[i + 1]['label'] as String,
                                  ),
                                )
                              : const SizedBox.shrink(),
                        ),
                      ],
                    ),
                  ),
              ],
            );
          }),
          Obx(() {
            final defaults = HostelSetupController.facilityOptions
                .map((e) => e['label'] as String)
                .toSet();
            final custom = controller.selectedFacilities
                .where((f) => !defaults.contains(f))
                .toList();
            if (custom.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 12),
              child: Column(
                children: [
                  for (int i = 0; i < custom.length; i += 2)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i + 2 < custom.length ? 12 : 0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _FacilityChip(
                              label: custom[i],
                              icon: Icons.star_rounded,
                              selected: true,
                              onTap: () =>
                                  controller.toggleFacility(custom[i]),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: i + 1 < custom.length
                                ? _FacilityChip(
                                    label: custom[i + 1],
                                    icon: Icons.star_rounded,
                                    selected: true,
                                    onTap: () => controller
                                        .toggleFacility(custom[i + 1]),
                                  )
                                : const SizedBox.shrink(),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            );
          }),
          const SizedBox(height: 18),
          Center(
            child: GestureDetector(
              onTap: () => _showCustomFacilitySheet(context),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(24),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.35),
                  ),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.add_rounded,
                        size: 18, color: AppColors.primary),
                    SizedBox(width: 6),
                    Text(
                      'Add a custom facility',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.primary,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomFacilitySheet(BuildContext context) {
    controller.customFacilityController.clear();
    Get.bottomSheet(
      isScrollControlled: true,
      Container(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Text(
              'Custom facility',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.customFacilityController,
              autofocus: true,
              style: const TextStyle(color: AppColors.textPrimary, fontSize: 15),
              cursorColor: AppColors.primary,
              decoration: InputDecoration(
                hintText: 'e.g. Gym, Rooftop, Study room',
                hintStyle: const TextStyle(color: AppColors.textMuted),
                filled: true,
                fillColor: AppColors.surfaceSoft,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(color: AppColors.border),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: const BorderSide(
                    color: AppColors.primary,
                    width: 1.5,
                  ),
                ),
              ),
              onSubmitted: (_) {
                controller.addCustomFacility();
                Get.back();
              },
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 48,
              child: ElevatedButton(
                onPressed: () {
                  controller.addCustomFacility();
                  Get.back();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.accent,
                  foregroundColor: Colors.white,
                  elevation: 0,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'Add',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// Boys / Girls — high beam (selected) vs low beam (idle)
class _HostelTypeSelector extends StatelessWidget {
  const _HostelTypeSelector({required this.selected, required this.onSelect});
  final String selected;
  final ValueChanged<String> onSelect;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _HostelTypeCard(
          label: 'Boys Hostel',
          subtitle: 'Male residents only',
          icon: Icons.male_rounded,
          selected: selected == 'Boys Hostel',
          onTap: () => onSelect('Boys Hostel'),
        ),
        const SizedBox(height: 10),
        _HostelTypeCard(
          label: 'Girls Hostel',
          subtitle: 'Female residents only',
          icon: Icons.female_rounded,
          selected: selected == 'Girls Hostel',
          onTap: () => onSelect('Girls Hostel'),
        ),
      ],
    );
  }
}

class _HostelTypeCard extends StatelessWidget {
  const _HostelTypeCard({
    required this.label,
    required this.subtitle,
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String subtitle;
  final IconData icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: selected
              ? AppColors.accent.withValues(alpha: 0.1)
              : Colors.white,
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 22,
              color: selected ? AppColors.accent : AppColors.textMuted,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: selected
                          ? AppColors.accent
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
            if (selected)
              const Icon(
                Icons.check_circle_rounded,
                size: 22,
                color: AppColors.accent,
              ),
          ],
        ),
      ),
    );
  }
}
// ═══════════════════════════════════════════
// Shared
// ═══════════════════════════════════════════

class _FacilityChip extends StatelessWidget {
  const _FacilityChip({
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
        duration: const Duration(milliseconds: 200),
        width: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 20,
              color: selected ? Colors.white : AppColors.accent,
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected ? Colors.white : AppColors.textPrimary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SelectChip extends StatelessWidget {
  const _SelectChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (selected) ...[
              const Icon(Icons.check_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 5),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected ? Colors.white : AppColors.textPrimary,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LightField extends StatelessWidget {
  const _LightField({
    required this.controller,
    required this.label,
    required this.hint,
    this.validator,
    this.keyboardType,
    this.prefixIcon,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final IconData? prefixIcon;
  final TextCapitalization textCapitalization;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 2, bottom: 8),
          child: Text(
            label,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          maxLines: maxLines,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: AppColors.textPrimary,
          ),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle:
                const TextStyle(fontSize: 14, color: AppColors.textMuted),
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 15,
            ),
            prefixIcon: prefixIcon != null && maxLines == 1
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child:
                        Icon(prefixIcon, size: 20, color: AppColors.accent),
                  )
                : null,
            prefixIconConstraints:
                const BoxConstraints(minWidth: 0, minHeight: 0),
            isDense: true,
            border: _border(AppColors.border),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: AppColors.error,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1.0}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(maxLines > 1 ? 16 : 28),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

class _TealButton extends StatelessWidget {
  const _TealButton({
    required this.label,
    required this.onTap,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 54,
      width: double.infinity,
      child: ElevatedButton(
        onPressed: isLoading ? null : onTap,
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.accent,
          foregroundColor: Colors.white,
          disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.55),
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
        ),
        child: isLoading
            ? const SizedBox(
                width: 22,
                height: 22,
                child: CircularProgressIndicator(
                  strokeWidth: 2.4,
                  color: Colors.white,
                ),
              )
            : Text(
                label,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                ),
              ),
      ),
    );
  }
}