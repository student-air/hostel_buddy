import 'package:flutter/material.dart';

import 'dart:ui';

import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class ProfileController extends GetxController {
  final _box = GetStorage();
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  final isEditing = false.obs;
  final isLoading = false.obs;
  final photoPath = RxnString();
  final role = ''.obs;
  final occupation = ''.obs;

  // Reactive display fields
  final displayName = 'User'.obs;
  final initials = '?'.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() {
    final name = _box.read('profile_name')?.toString().trim() ?? '';
    final phone = _box.read('profile_phone')?.toString().trim() ?? '';
    final city = _box.read('profile_city')?.toString().trim() ?? '';
    final photo = _box.read('profile_photo')?.toString();
    final storedRole = _box.read('user_role')?.toString() ?? '';
    final occ = _box.read('profile_occupation')?.toString() ?? 'student';

    nameController.text = name;
    phoneController.text = phone;
    cityController.text = city;
    if (photo != null && photo.isNotEmpty) photoPath.value = photo;
    role.value = storedRole;
    occupation.value = occ;

    _updateDisplayName(name);
  }

  void _updateDisplayName(String name) {
    final trimmed = name.trim();
    displayName.value = trimmed.isEmpty ? 'User' : trimmed;

    final parts = trimmed.split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) {
      initials.value = '?';
    } else if (parts.length == 1) {
      initials.value = parts.first[0].toUpperCase();
    } else {
      initials.value = '${parts.first[0]}${parts.last[0]}'.toUpperCase();
    }
  }

  String get roleLabel {
    if (role.value == AppConstants.roleManager) return 'Listing hostels';
    if (role.value == AppConstants.roleSeeker) return 'Finding a hostel';
    return 'User';
  }

  void toggleEdit() {
    if (isEditing.value) {
      _loadProfile();
    }
    isEditing.value = !isEditing.value;
  }

  Future<void> pickPhoto() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (file == null) return;

      final cropped = await ImageCropper().cropImage(
        sourcePath: file.path,
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),
        uiSettings: [
          AndroidUiSettings(
            toolbarTitle: 'Crop photo',
            toolbarColor: AppColors.primary,
            toolbarWidgetColor: Colors.white,
            activeControlsWidgetColor: AppColors.accent,
            initAspectRatio: CropAspectRatioPreset.square,
            lockAspectRatio: true,
            statusBarColor: AppColors.primaryDark,
            backgroundColor: AppColors.primaryDeep,
          ),
          IOSUiSettings(
            title: 'Crop photo',
            aspectRatioLockEnabled: true,
            resetAspectRatioEnabled: false,
            aspectRatioPickerButtonHidden: true,
            doneButtonTitle: 'Done',
            cancelButtonTitle: 'Cancel',
          ),
        ],
        compressFormat: ImageCompressFormat.jpg,
        compressQuality: 88,
      );

      if (cropped != null) {
        photoPath.value = cropped.path;
      }
    } catch (_) {
      AppSnackbar.error('Photo', 'Could not pick or crop image.');
    }
  }

  Future<void> saveProfile() async {
    if (!formKey.currentState!.validate()) return;

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 600));

    final name = nameController.text.trim();
    await _box.write('profile_name', name);
    await _box.write('profile_phone', phoneController.text.trim());
    await _box.write('profile_city', cityController.text.trim());
    if (photoPath.value != null) {
      await _box.write('profile_photo', photoPath.value);
    }

    _updateDisplayName(name);

    isLoading.value = false;
    isEditing.value = false;

    AppSnackbar.success('Profile updated', 'Your changes have been saved.');
  }

  // ── Menu actions ──

  void onNotifications() {
    AppSnackbar.info('Notifications', 'Coming next.');
  }

  void onSavedHostels() {
    AppSnackbar.info('Saved hostels', 'Coming next.');
  }

  void onPaymentMethods() {
    AppSnackbar.info('Payment methods', 'Coming next.');
  }

  void onPrivacy() {
    AppSnackbar.info('Privacy and security', 'Coming next.');
  }

  void onHelp() {
    AppSnackbar.info('Help and support', 'Coming next.');
  }

  void onTerms() {
    AppSnackbar.info('Terms of service', 'Coming next.');
  }

  void onLogout() {
  Get.dialog(
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 28),
      child: Container(
        padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
        decoration: BoxDecoration(
          color: Colors.white, // solid white like navbar
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 20,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: AppColors.error.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.logout_rounded,
                size: 28,
                color: AppColors.error,
              ),
            ),
            const SizedBox(height: 18),
            const Text(
              'Log out?',
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 20,
                fontWeight: FontWeight.w800,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'Are you sure you want to log out of Hostel Buddy?',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: AppColors.accent,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        backgroundColor: Colors.white,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Cancel',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: SizedBox(
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        AppSnackbar.info('Logged out', 'Session ended.');
                        Get.offAllNamed(AppRoutes.auth);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.error,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text(
                        'Log out',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    ),
    barrierColor: Colors.black.withValues(alpha: 0.35),
  );
}

  void goBack() => Get.back();

  @override
  void onClose() {
    nameController.dispose();
    phoneController.dispose();
    cityController.dispose();
    super.onClose();
  }
}
