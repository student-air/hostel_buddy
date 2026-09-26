import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../controllers/hostel_setup_controller.dart';

class HostelSetupView extends GetView<HostelSetupController> {
  const HostelSetupView({super.key});

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
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
                    Color(0xFF3C0515),
                    Color(0xFF2A0412),
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
            ),
            Positioned(
              top: -40,
              right: -50,
              child: _DecorCircle(
                size: 200,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            Positioned(
              top: 100,
              right: -20,
              child: _DecorCircle(
                size: 140,
                color: const Color(0xFF2A1840).withValues(alpha: 0.4),
              ),
            ),
            Positioned(
              bottom: 160,
              left: -70,
              child: _DecorCircle(
                size: 180,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            SafeArea(
              child: Column(
                children: [
                  Obx(
                    () => _TopBar(
                      progress: (controller.currentStep.value + 1) / 3,
                      stepLabel: '${controller.currentStep.value + 1}/3',
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
                    padding: EdgeInsets.fromLTRB(28, 8, 28, 12 + bottomPad),
                    child: Obx(() {
                      final step = controller.currentStep.value;
                      final isLast = step == 2;
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
          ],
        ),
      ),
    );
  }
}

class _TopBar extends StatelessWidget {
  const _TopBar({
    required this.progress,
    required this.stepLabel,
    required this.onBack,
  });

  final double progress;
  final String stepLabel;
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 4,
                backgroundColor: Colors.white.withValues(alpha: 0.15),
                valueColor: const AlwaysStoppedAnimation<Color>(
                  AppColors.accent,
                ),
              ),
            ),
          ),
          const SizedBox(width: 14),
          Text(
            stepLabel,
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: Colors.white.withValues(alpha: 0.7),
            ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STEP 1 — Basics (pictures at top)
// ═══════════════════════════════════════════

class _StepBasics extends StatelessWidget {
  const _StepBasics({required this.controller});

  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
      physics: const BouncingScrollPhysics(),
      child: Form(
        key: controller.basicsFormKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tell us about your place',
              style: TextStyle(
                fontFamily: 'Inter',
                fontSize: 26,
                fontWeight: FontWeight.w700,
                color: Colors.white,
                letterSpacing: -0.4,
                height: 1.2,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'This shows up on your public listing',
              style: TextStyle(
                fontSize: 14,
                color: Colors.white.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: 22),

            // Pictures — TOP
            Text(
              'Pictures',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: AppColors.textSecondary.withValues(alpha: 0.95),
              ),
            ),
            const SizedBox(height: 12),
            _PhotoPickerSection(controller: controller),

            const SizedBox(height: 20),
            _GlassField(
              controller: controller.nameController,
              label: 'Hostel name',
              hint: 'Green Valley Hostel',
              validator: Validators.hostelName,
              prefixIcon: Icons.home_outlined,

              textCapitalization: TextCapitalization.words,
            ),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: _GlassField(
                    controller: controller.areaController,
                    label: 'Area',
                    hint: 'G-9',
                    validator: (v) => Validators.required(v, fieldName: 'Area'),
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _GlassField(
                    controller: controller.cityController,
                    label: 'City',
                    hint: 'Islamabad',
                    validator: Validators.city,
                    textCapitalization: TextCapitalization.words,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            _GlassField(
              controller: controller.contactController,
              label: 'Contact number',
              hint: '+92 51 1234567',
              validator: Validators.phone,
              prefixIcon: Icons.phone_outlined,
              keyboardType: TextInputType.phone,
            ),
            const SizedBox(height: 16),
            _GlassField(
              controller: controller.descriptionController,
              label: 'Description',
              hint: 'Shared rooms 5 minutes from campus, common study hall, laundry twice a week…',
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

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      final paths = controller.photoPaths.toList(); // must read observable here
      return SizedBox(
        height: 88,
        child: ListView(
          scrollDirection: Axis.horizontal,
          children: [
            GestureDetector(
              onTap: controller.pickPhotos,
              child: Stack(
                clipBehavior: Clip.none,
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: Colors.white.withValues(alpha: 0.25),
                        width: 1.5,
                      ),
                    ),
                    child: Icon(
                      Icons.add_a_photo_outlined,
                      size: 28,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                  Positioned(
                    right: -2,
                    bottom: -2,
                    child: Container(
                      width: 28,
                      height: 28,
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF3C0515),
                          width: 2.5,
                        ),
                      ),
                      child: const Icon(
                        Icons.camera_alt_rounded,
                        size: 13,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            if (paths.isNotEmpty) const SizedBox(width: 12),
            ...List.generate(paths.length, (i) {
              return Padding(
                padding: EdgeInsets.only(right: i < paths.length - 1 ? 10 : 0),
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 80,
                      height: 80,
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
          ],
        ),
      );
    });
  }
}
// ═══════════════════════════════════════════
// STEP 2 — Rooms (editable number + steppers)
// ═══════════════════════════════════════════

class _StepRooms extends StatelessWidget {
  const _StepRooms({required this.controller});

  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Rooms & capacity',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'How many rooms, and what kind',
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Total rooms',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _RoundIconButton(
                icon: Icons.remove_rounded,
                onTap: controller.decrementRooms,
              ),
              const SizedBox(width: 20),
              // Editable number
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
                    fontWeight: FontWeight.w700,
                    color: Colors.white,
                    letterSpacing: -1,
                  ),
                  cursorColor: AppColors.accent,
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
              ),
            ],
          ),
          const SizedBox(height: 8),
          Center(
            child: Text(
              'Tap the number to type',
              style: TextStyle(
                fontSize: 12,
                color: Colors.white.withValues(alpha: 0.4),
              ),
            ),
          ),
          const SizedBox(height: 32),
          Text(
            'Room type — select all that apply',
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.95),
            ),
          ),
          const SizedBox(height: 14),
          Obx(
            () => Wrap(
              spacing: 10,
              runSpacing: 10,
              children: HostelSetupController.roomTypeOptions.map((type) {
                final selected = controller.selectedRoomTypes.contains(type);
                return _SelectChip(
                  label: type,
                  selected: selected,
                  showCheck: true,
                  onTap: () => controller.toggleRoomType(type),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class _RoundIconButton extends StatelessWidget {
  const _RoundIconButton({required this.icon, required this.onTap});

  final IconData icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white.withValues(alpha: 0.12),
          border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
        ),
        child: Icon(icon, color: Colors.white, size: 24),
      ),
    );
  }
}

// ═══════════════════════════════════════════
// STEP 3 — Facilities (2-column grid)
// ═══════════════════════════════════════════

class _StepFacilities extends StatelessWidget {
  const _StepFacilities({required this.controller});

  final HostelSetupController controller;

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(28, 8, 28, 16),
      physics: const BouncingScrollPhysics(),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Facilities & amenities',
            style: TextStyle(
              fontFamily: 'Inter',
              fontSize: 26,
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: -0.4,
              height: 1.2,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            "What's included for residents",
            style: TextStyle(
              fontSize: 14,
              color: Colors.white.withValues(alpha: 0.6),
            ),
          ),
          const SizedBox(height: 24),

          // 2-column grid
          Obx(() {
            final items = HostelSetupController.facilityOptions;
            return Column(
              children: [
                for (int i = 0; i < items.length; i += 2)
                  Padding(
                    padding: EdgeInsets.only(
                      bottom: i + 2 < items.length ? 10 : 0,
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: _FacilityChip(
                            label: items[i]['label'] as String,
                            icon: items[i]['icon'] as IconData,
                            selected: controller.selectedFacilities.contains(
                              items[i]['label'],
                            ),
                            onTap: () => controller.toggleFacility(
                              items[i]['label'] as String,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
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

          // Custom facilities
          Obx(() {
            final defaults = HostelSetupController.facilityOptions
                .map((e) => e['label'] as String)
                .toSet();
            final custom = controller.selectedFacilities
                .where((f) => !defaults.contains(f))
                .toList();
            if (custom.isEmpty) return const SizedBox.shrink();
            return Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Column(
                children: [
                  for (int i = 0; i < custom.length; i += 2)
                    Padding(
                      padding: EdgeInsets.only(
                        bottom: i + 2 < custom.length ? 10 : 0,
                      ),
                      child: Row(
                        children: [
                          Expanded(
                            child: _FacilityChip(
                              label: custom[i],
                              icon: Icons.star_rounded,
                              selected: true,
                              onTap: () => controller.toggleFacility(custom[i]),
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: i + 1 < custom.length
                                ? _FacilityChip(
                                    label: custom[i + 1],
                                    icon: Icons.star_rounded,
                                    selected: true,
                                    onTap: () => controller.toggleFacility(
                                      custom[i + 1],
                                    ),
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

          const SizedBox(height: 20),
          GestureDetector(
            onTap: () => _showCustomFacilitySheet(context),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 18, color: AppColors.accent),
                SizedBox(width: 6),
                Text(
                  'Add a custom facility',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.accent,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showCustomFacilitySheet(BuildContext context) {
    controller.customFacilityController.clear();
    Get.bottomSheet(
      Container(
        padding: EdgeInsets.fromLTRB(
          24,
          20,
          24,
          20 + MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Color(0xFF2A0412),
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
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: controller.customFacilityController,
              autofocus: true,
              style: const TextStyle(color: Colors.white, fontSize: 15),
              cursorColor: AppColors.accent,
              decoration: InputDecoration(
                hintText: 'e.g. Gym, Rooftop, Study room',
                hintStyle: TextStyle(
                  color: Colors.white.withValues(alpha: 0.4),
                ),
                filled: true,
                fillColor: Colors.white.withValues(alpha: 0.1),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
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
      isScrollControlled: true,
    );
  }
}

// ═══════════════════════════════════════════
// Shared widgets
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
          color: selected
              ? AppColors.accent
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : Colors.white.withValues(alpha: 0.15),
          ),
        ),
        child: Row(
          children: [
            Icon(
              icon,
              size: 18,
              color: selected
                  ? Colors.white
                  : Colors.white.withValues(alpha: 0.6),
            ),
            const SizedBox(width: 8),
            Flexible(
              child: Text(
                label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: selected
                      ? Colors.white
                      : Colors.white.withValues(alpha: 0.75),
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
    this.showCheck = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final bool showCheck;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent
              : Colors.white.withValues(alpha: 0.08),
          borderRadius: BorderRadius.circular(28),
          border: Border.all(
            color: selected
                ? AppColors.accent
                : Colors.white.withValues(alpha: 0.18),
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (showCheck && selected) ...[
              const Icon(Icons.check_rounded, size: 16, color: Colors.white),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: selected
                    ? Colors.white
                    : Colors.white.withValues(alpha: 0.75),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _GlassField extends StatelessWidget {
  const _GlassField({
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
            style: TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: AppColors.textSecondary.withValues(alpha: 0.95),
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
            color: Colors.white,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary.withValues(alpha: 0.65),
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.14),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 16,
            ),
            prefixIcon: prefixIcon != null && maxLines == 1
                ? Padding(
                    padding: const EdgeInsets.only(left: 14, right: 10),
                    child: Icon(
                      prefixIcon,
                      size: 20,
                      color: AppColors.textSecondary,
                    ),
                  )
                : null,
            prefixIconConstraints: const BoxConstraints(
              minWidth: 0,
              minHeight: 0,
            ),
            isDense: true,
            border: _border(Colors.white.withValues(alpha: 0.22)),
            enabledBorder: _border(Colors.white.withValues(alpha: 0.22)),
            focusedBorder: _border(AppColors.accent, width: 1.5),
            errorBorder: _border(AppColors.error),
            focusedErrorBorder: _border(AppColors.error, width: 1.5),
            errorStyle: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Color(0xFFFF8A9A),
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
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
      ),
    );
  }
}

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

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
