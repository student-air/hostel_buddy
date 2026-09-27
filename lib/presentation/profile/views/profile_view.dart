import 'dart:io';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/validators.dart';
import '../controllers/profile_controller.dart';

class ProfileView extends GetView<ProfileController> {
  const ProfileView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: Scaffold(
          body: Stack(
            children: [
              // Background gradient
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
              // Decorative blobs
              Positioned(
                top: -50,
                right: -30,
                child: _Blob(
                  size: 200,
                  color: AppColors.accent.withValues(alpha: 0.07),
                ),
              ),
              Positioned(
                bottom: 100,
                left: -60,
                child: _Blob(
                  size: 180,
                  color: Colors.white.withValues(alpha: 0.03),
                ),
              ),
              SafeArea(
                child: Column(
                  children: [
                    _TopBar(controller: controller),
                    Expanded(
                      child: SingleChildScrollView(
                        physics: const BouncingScrollPhysics(),
                        padding: const EdgeInsets.fromLTRB(20, 8, 20, 32),
                        child: Form(
                          key: controller.formKey,
                          child: Column(
                            children: [
                              const SizedBox(height: 8),
                              _AvatarSection(controller: controller),
                              const SizedBox(height: 28),
                              _InfoCard(controller: controller),
                              const SizedBox(height: 20),
                              _ActionButtons(controller: controller),
                            ],
                          ),
                        ),
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

// ═══════════════════════════════════════════
// TOP BAR
// ═══════════════════════════════════════════

class _TopBar extends StatelessWidget {
  const _TopBar({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 16, 4),
      child: Row(
        children: [
          IconButton(
            onPressed: controller.goBack,
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              size: 18,
              color: Colors.white,
            ),
          ),
          const Expanded(
            child: Text(
              'Profile',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Obx(
            () => controller.isEditing.value
                ? TextButton(
                    onPressed: controller.toggleEdit,
                    child: Text(
                      'Cancel',
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.7),
                        fontWeight: FontWeight.w600,
                        fontSize: 14,
                      ),
                    ),
                  )
                : IconButton(
                    onPressed: controller.toggleEdit,
                    icon: const Icon(
                      Icons.edit_rounded,
                      size: 20,
                      color: AppColors.accentLight,
                    ),
                  ),
          ),
        ],
      ),
    );
  }
}

// ═══════════════════════════════════════════
// AVATAR + NAME
// ═══════════════════════════════════════════

class _AvatarSection extends StatelessWidget {
  const _AvatarSection({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        GestureDetector(
          onTap: () {
            if (controller.isEditing.value) controller.pickPhoto();
          },
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Obx(() {
                final path = controller.photoPath.value;
                return Container(
                  width: 110,
                  height: 110,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.accent.withValues(alpha: 0.25),
                    border: Border.all(
                      color: AppColors.accent.withValues(alpha: 0.55),
                      width: 2.5,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.accent.withValues(alpha: 0.2),
                        blurRadius: 24,
                        spreadRadius: 2,
                      ),
                    ],
                    image: path != null
                        ? DecorationImage(
                            image: FileImage(File(path)),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  alignment: Alignment.center,
                  child: path == null
                      ? Text(
                          controller.initials,
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 36,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        )
                      : null,
                );
              }),
              Obx(
                () => controller.isEditing.value
                    ? Positioned(
                        right: 2,
                        bottom: 2,
                        child: Container(
                          width: 34,
                          height: 34,
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
                            size: 16,
                            color: Colors.white,
                          ),
                        ),
                      )
                    : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Obx(
          () => Text(
            controller.displayName,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.w800,
              letterSpacing: -0.4,
            ),
          ),
        ),
        const SizedBox(height: 8),
        Obx(
          () => Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 5),
            decoration: BoxDecoration(
              color: AppColors.accent.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: AppColors.accent.withValues(alpha: 0.4),
              ),
            ),
            child: Text(
              controller.roleLabel,
              style: const TextStyle(
                color: AppColors.accentLight,
                fontSize: 12,
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
// INFO CARD
// ═══════════════════════════════════════════

class _InfoCard extends StatelessWidget {
  const _InfoCard({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(22),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Colors.white.withValues(alpha: 0.14),
                Colors.white.withValues(alpha: 0.05),
              ],
            ),
            border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
          ),
          child: Obx(
            () => Column(
              children: [
                if (controller.isEditing.value) ...[
                  _EditField(
                    controller: controller.nameController,
                    label: 'Full name',
                    hint: 'John Doe',
                    icon: Icons.person_outline_rounded,
                    validator: Validators.name,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 16),
                  _EditField(
                    controller: controller.phoneController,
                    label: 'Phone number',
                    hint: '+92 300 1234567',
                    icon: Icons.phone_outlined,
                    validator: Validators.phone,
                    keyboardType: TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  _EditField(
                    controller: controller.cityController,
                    label: 'City',
                    hint: 'e.g. Islamabad',
                    icon: Icons.location_on_outlined,
                    validator: Validators.city,
                    textCapitalization: TextCapitalization.words,
                  ),
                  const SizedBox(height: 12),
                ] else ...[
                  _InfoRow(
                    icon: Icons.person_outline_rounded,
                    label: 'Name',
                    value: controller.displayName,
                  ),
                  _InfoRow(
                    icon: Icons.phone_outlined,
                    label: 'Phone',
                    value: controller.phoneController.text.trim().isEmpty
                        ? 'Not set'
                        : controller.phoneController.text.trim(),
                  ),
                  _InfoRow(
                    icon: Icons.location_on_outlined,
                    label: 'City',
                    value: controller.cityController.text.trim().isEmpty
                        ? 'Not set'
                        : controller.cityController.text.trim(),
                  ),
                  _InfoRow(
                    icon: Icons.badge_outlined,
                    label: 'Role',
                    value: controller.roleLabel,
                    isLast: true,
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _InfoRow extends StatelessWidget {
  const _InfoRow({
    required this.icon,
    required this.label,
    required this.value,
    this.isLast = false,
  });

  final IconData icon;
  final String label;
  final String value;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              Container(
                width: 38,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.accent.withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, size: 18, color: AppColors.accentLight),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.45),
                        fontSize: 12,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      value,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        if (!isLast)
          Divider(
            color: Colors.white.withValues(alpha: 0.08),
            height: 1,
          ),
      ],
    );
  }
}

class _EditField extends StatelessWidget {
  const _EditField({
    required this.controller,
    required this.label,
    required this.hint,
    required this.icon,
    this.validator,
    this.keyboardType,
    this.textCapitalization = TextCapitalization.none,
  });

  final TextEditingController controller;
  final String label;
  final String hint;
  final IconData icon;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextCapitalization textCapitalization;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.white.withValues(alpha: 0.55),
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          validator: validator,
          keyboardType: keyboardType,
          textCapitalization: textCapitalization,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 15,
            fontWeight: FontWeight.w500,
          ),
          cursorColor: AppColors.accent,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: TextStyle(
              color: Colors.white.withValues(alpha: 0.3),
              fontSize: 14,
            ),
            filled: true,
            fillColor: Colors.white.withValues(alpha: 0.1),
            contentPadding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ),
            prefixIcon: Icon(icon, size: 20, color: AppColors.accentLight),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: BorderSide(
                color: Colors.white.withValues(alpha: 0.15),
              ),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(
                color: AppColors.accent,
                width: 1.5,
              ),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(16),
              borderSide: const BorderSide(color: AppColors.error, width: 1.5),
            ),
            errorStyle: const TextStyle(
              fontSize: 12,
              color: Color(0xFFFF8A9A),
            ),
          ),
        ),
      ],
    );
  }
}

// ═══════════════════════════════════════════
// ACTION BUTTONS
// ═══════════════════════════════════════════

class _ActionButtons extends StatelessWidget {
  const _ActionButtons({required this.controller});
  final ProfileController controller;

  @override
  Widget build(BuildContext context) {
    return Obx(() {
      if (controller.isEditing.value) {
        return SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton(
            onPressed: controller.isLoading.value ? null : controller.saveProfile,
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.accent,
              foregroundColor: Colors.white,
              disabledBackgroundColor: AppColors.accent.withValues(alpha: 0.5),
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
            ),
            child: controller.isLoading.value
                ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.4,
                      color: Colors.white,
                    ),
                  )
                : const Text(
                    'Save changes',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
          ),
        );
      }

      return Column(
        children: [
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: controller.toggleEdit,
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.white,
                side: BorderSide(
                  color: Colors.white.withValues(alpha: 0.25),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              icon: const Icon(Icons.edit_rounded, size: 18),
              label: const Text(
                'Edit profile',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton.icon(
              onPressed: controller.onLogout,
              style: OutlinedButton.styleFrom(
                foregroundColor: AppColors.error,
                side: BorderSide(
                  color: AppColors.error.withValues(alpha: 0.4),
                ),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(28),
                ),
              ),
              icon: const Icon(Icons.logout_rounded, size: 18),
              label: const Text(
                'Log out',
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),
            ),
          ),
        ],
      );
    });
  }
}

// ═══════════════════════════════════════════
// HELPERS
// ═══════════════════════════════════════════

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
