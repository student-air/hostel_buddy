import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';

class HostelSetupController extends GetxController {
  final pageController = PageController();
  final currentStep = 0.obs; // 0, 1, 2
  final isLoading = false.obs;

  // ── Step 1: Basics ──
  final basicsFormKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final areaController = TextEditingController();
  final cityController = TextEditingController();
  final contactController = TextEditingController();
  final descriptionController = TextEditingController();
  final photoPaths = <String>[].obs;

  // ── Step 2: Rooms ──
  final totalRooms = 1.obs;
  late final TextEditingController roomsTextController;
  final selectedRoomTypes = <String>{}.obs;

  static const List<String> roomTypeOptions = [
    'Single',
    '3-seater',
    '4-seater',
    '5-seater',
    'Dorm',
  ];

  // ── Step 3: Facilities ──
  final selectedFacilities = <String>{}.obs;
  final customFacilityController = TextEditingController();

  static const List<Map<String, dynamic>> facilityOptions = [
    {'label': 'WiFi', 'icon': Icons.wifi_rounded},
    {'label': 'AC', 'icon': Icons.ac_unit_rounded},
    {'label': 'Heater', 'icon': Icons.whatshot_rounded},
    {'label': 'Ironing', 'icon': Icons.iron_rounded},
    {'label': 'Meals', 'icon': Icons.restaurant_rounded},
    {'label': 'Parking', 'icon': Icons.local_parking_rounded},
    {'label': 'Laundry', 'icon': Icons.local_laundry_service_rounded},
    {'label': 'Security', 'icon': Icons.security_rounded},
  ];

  final ImagePicker _picker = ImagePicker();

  @override
  void onInit() {
    super.onInit();
    roomsTextController = TextEditingController(text: '1');
  }

  void goToStep(int step) {
    currentStep.value = step;
    pageController.animateToPage(
      step,
      duration: const Duration(milliseconds: 320),
      curve: Curves.easeOutCubic,
    );
  }

  void nextStep() {
    if (currentStep.value == 0) {
      if (!_validateBasics()) return;
      goToStep(1);
    } else if (currentStep.value == 1) {
      if (!_validateRooms()) return;
      goToStep(2);
    }
  }

  void previousStep() {
    if (currentStep.value > 0) {
      goToStep(currentStep.value - 1);
    } else {
      Get.back();
    }
  }

  bool _validateBasics() {
    if (!basicsFormKey.currentState!.validate()) return false;
    return true;
  }

  bool _validateRooms() {
    _syncRoomsFromText();
    if (totalRooms.value < 1) {
      AppSnackbar.warning('Rooms', 'Enter at least 1 room.');
      return false;
    }
    if (selectedRoomTypes.isEmpty) {
      AppSnackbar.warning('Room type', 'Select at least one room type.');
      return false;
    }
    return true;
  }

  void _syncRoomsFromText() {
    final parsed = int.tryParse(roomsTextController.text.trim());
    if (parsed != null && parsed >= 1) {
      totalRooms.value = parsed.clamp(1, 200);
      roomsTextController.text = '${totalRooms.value}';
    } else {
      totalRooms.value = 1;
      roomsTextController.text = '1';
    }
  }

  void onRoomsTextChanged(String value) {
    final parsed = int.tryParse(value.trim());
    if (parsed != null && parsed >= 1) {
      totalRooms.value = parsed.clamp(1, 200);
    }
  }

  void incrementRooms() {
    if (totalRooms.value < 200) {
      totalRooms.value++;
      roomsTextController.text = '${totalRooms.value}';
    }
  }

  void decrementRooms() {
    if (totalRooms.value > 1) {
      totalRooms.value--;
      roomsTextController.text = '${totalRooms.value}';
    }
  }

  void toggleRoomType(String type) {
    if (selectedRoomTypes.contains(type)) {
      selectedRoomTypes.remove(type);
    } else {
      selectedRoomTypes.add(type);
    }
  }

  void toggleFacility(String label) {
    if (selectedFacilities.contains(label)) {
      selectedFacilities.remove(label);
    } else {
      selectedFacilities.add(label);
    }
  }

  void addCustomFacility() {
    final text = customFacilityController.text.trim();
    if (text.isEmpty) return;
    selectedFacilities.add(text);
    customFacilityController.clear();
  }

  final customRoomTypeController = TextEditingController();

  void addCustomRoomType() {
    final text = customRoomTypeController.text.trim();
    if (text.isEmpty) return;
    selectedRoomTypes.add(text);
    customRoomTypeController.clear();
  }

  Future<void> pickPhotos() async {
    try {
      final remaining = AppConstants.maxHostelPhotos - photoPaths.length;
      if (remaining <= 0) {
        AppSnackbar.warning(
          'Photos',
          'Maximum ${AppConstants.maxHostelPhotos} photos.',
        );
        return;
      }
      final files = await _picker.pickMultiImage(
        imageQuality: 85,
        limit: remaining,
      );
      if (files.isEmpty) return;
      for (final f in files) {
        if (photoPaths.length >= AppConstants.maxHostelPhotos) break;
        photoPaths.add(f.path);
      }
    } catch (_) {
      AppSnackbar.error('Photos', 'Could not pick images.');
    }
  }

  void removePhoto(int index) {
    if (index >= 0 && index < photoPaths.length) {
      photoPaths.removeAt(index);
    }
  }

  Future<void> publishListing() async {
    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;

    AppSnackbar.success(
      'Published',
      '${nameController.text.trim()} is now live!',
    );
    // TODO: Navigate to manager home / dashboard
  }

  @override
  void onClose() {
    pageController.dispose();
    nameController.dispose();
    areaController.dispose();
    cityController.dispose();
    contactController.dispose();
    descriptionController.dispose();
    roomsTextController.dispose();
    customFacilityController.dispose();
    customRoomTypeController.dispose();
    super.onClose();
  }
}
