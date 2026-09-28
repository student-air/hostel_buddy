import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:image_picker/image_picker.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

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
  final customRoomTypeController = TextEditingController();

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

  /// Hostel type: 'Boys Hostel' | 'Girls Hostel' | ''
  final selectedHostelType = ''.obs;

  static const List<String> hostelTypeOptions = ['Boys Hostel', 'Girls Hostel'];

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

  void addCustomRoomType() {
    final text = customRoomTypeController.text.trim();
    if (text.isEmpty) return;
    selectedRoomTypes.add(text);
    customRoomTypeController.clear();
  }

  void selectHostelType(String type) {
    selectedHostelType.value = type;
  }

  void toggleFacility(String label) {
    if (selectedFacilities.contains(label)) {
      selectedFacilities.remove(label);
    } else {
      selectedFacilities.add(label);
    }
  }

  void toggleSelectAllFacilities() {
    final allLabels = facilityOptions.map((e) => e['label'] as String).toSet();
    final allSelected = allLabels.every(selectedFacilities.contains);
    if (allSelected) {
      selectedFacilities.removeAll(allLabels);
    } else {
      selectedFacilities.addAll(allLabels);
    }
  }

  bool get allFacilitiesSelected {
    final allLabels = facilityOptions.map((e) => e['label'] as String).toSet();
    return allLabels.isNotEmpty && allLabels.every(selectedFacilities.contains);
  }

  void addCustomFacility() {
    final text = customFacilityController.text.trim();
    if (text.isEmpty) return;
    selectedFacilities.add(text);
    customFacilityController.clear();
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
    if (selectedHostelType.value.isEmpty) {
      AppSnackbar.warning('Hostel type', 'Select Boys or Girls hostel.');
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 900));
    isLoading.value = false;

    final box = GetStorage();
    final name = nameController.text.trim();
    final city = cityController.text.trim().isNotEmpty
        ? cityController.text.trim()
        : (box.read('profile_city')?.toString() ?? 'Islamabad');
    final type = selectedHostelType.value;
    final area = areaController.text.trim();
    final contact = contactController.text.trim();
    final description = descriptionController.text.trim();

    // Legacy single keys (used across app)
    await box.write('hostel_name', name);
    await box.write('hostel_type', type);
    await box.write('hostel_area', area);
    await box.write('hostel_description', description);
    await box.write('hostel_contact', contact);
    await box.write('hostel_rooms', totalRooms.value);
    if (city.isNotEmpty) await box.write('profile_city', city);

    // Multi-hostel list used by Manager Home dropdown
    final existing = box.read('manager_hostels');
    final List<Map<String, dynamic>> list = [];
    if (existing is List) {
      for (final e in existing) {
        if (e is Map) list.add(Map<String, dynamic>.from(e));
      }
    }

    final newHostel = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': name,
      'city': city,
      'type': type,
    };

    // If editing same name, replace; else append
    final sameIndex = list.indexWhere(
      (h) => (h['name']?.toString() ?? '').toLowerCase() == name.toLowerCase(),
    );
    if (sameIndex >= 0) {
      list[sameIndex] = newHostel;
      await box.write('selected_hostel_index', sameIndex);
    } else {
      list.add(newHostel);
      await box.write('selected_hostel_index', list.length - 1);
    }
    await box.write('manager_hostels', list);

    AppSnackbar.success('Published', '$name is now live!');
    Get.offAllNamed(AppRoutes.managerHome);
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
    customRoomTypeController.dispose();
    customFacilityController.dispose();
    super.onClose();
  }
}
