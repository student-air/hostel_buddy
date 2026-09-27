import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../core/utils/validators.dart';
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
  }

  String get initials {
    final full = nameController.text.trim();
    final parts = full.split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get roleLabel {
    if (role.value == AppConstants.roleManager) return 'Hostel Manager';
    if (role.value == AppConstants.roleSeeker) return 'Finding a hostel';
    return 'User';
  }

  String get displayName {
    final name = nameController.text.trim();
    return name.isEmpty ? 'User' : name;
  }

  void toggleEdit() {
    if (isEditing.value) {
      // Cancel → reload original values
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

    await _box.write('profile_name', nameController.text.trim());
    await _box.write('profile_phone', phoneController.text.trim());
    await _box.write('profile_city', cityController.text.trim());
    if (photoPath.value != null) {
      await _box.write('profile_photo', photoPath.value);
    }

    isLoading.value = false;
    isEditing.value = false;

    AppSnackbar.success('Profile updated', 'Your changes have been saved.');
  }

  void onLogout() {
    Get.dialog(
      AlertDialog(
        backgroundColor: const Color(0xFF2A0412),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Log out',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Colors.white.withValues(alpha: 0.75)),
        ),
        actions: [
          TextButton(
            onPressed: () => Get.back(),
            child: Text(
              'Cancel',
              style: TextStyle(color: Colors.white.withValues(alpha: 0.6)),
            ),
          ),
          TextButton(
            onPressed: () {
              Get.back();
              AppSnackbar.info('Logged out', 'Session ended.');
              Get.offAllNamed(AppRoutes.auth);
            },
            child: const Text(
              'Log out',
              style: TextStyle(
                color: AppColors.error,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
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
