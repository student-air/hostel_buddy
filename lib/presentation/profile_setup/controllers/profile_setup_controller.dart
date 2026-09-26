import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';

class ProfileSetupController extends GetxController {
  final formKey = GlobalKey<FormState>();

  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final cityController = TextEditingController();

  final isLoading = false.obs;
  final photoPath = RxnString();
  final locationGranted = false.obs;
  final isLocating = false.obs;

  /// 'student' | 'job_holder'
  final occupation = 'student'.obs;

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    _importFromAuth();
  }

  /// Prefill name & phone from Auth (signup arguments).
  void _importFromAuth() {
    final args = Get.arguments;
    if (args is Map) {
      final name = args['name']?.toString().trim() ?? '';
      final phone = args['phone']?.toString().trim() ?? '';
      if (name.isNotEmpty) nameController.text = name;
      if (phone.isNotEmpty) phoneController.text = phone;
    }
  }

  void selectOccupation(String value) => occupation.value = value;

  /// Pick image → crop to 1:1 → save path.
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
            hideBottomControls: false,
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

  /// Request location permission.
  Future<void> requestLocation() async {
    isLocating.value = true;
    try {
      final serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        AppSnackbar.warning('Location', 'Please turn on location services.');
        isLocating.value = false;
        return;
      }

      var permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied) {
        AppSnackbar.warning('Location', 'Location permission denied.');
        locationGranted.value = false;
        isLocating.value = false;
        return;
      }

      if (permission == LocationPermission.deniedForever) {
        AppSnackbar.error(
          'Location',
          'Permission permanently denied. Open settings to enable.',
        );
        await openAppSettings();
        locationGranted.value = false;
        isLocating.value = false;
        return;
      }

      final position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.medium,
        ),
      );

      locationGranted.value = true;

      AppSnackbar.success(
        'Location enabled',
        'Lat ${position.latitude.toStringAsFixed(3)}, '
            'Lng ${position.longitude.toStringAsFixed(3)}. Confirm your city below.',
      );
    } catch (_) {
      AppSnackbar.error('Location', 'Could not get your location.');
      locationGranted.value = false;
    } finally {
      isLocating.value = false;
    }
  }

  Future<void> continueNext() async {
    if (!formKey.currentState!.validate()) return;

    if (cityController.text.trim().isEmpty) {
      AppSnackbar.warning('City', 'Please confirm your city.');
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 800));
    isLoading.value = false;

    AppSnackbar.success(
      'Profile saved',
      'Welcome, ${nameController.text.trim()}!',
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
