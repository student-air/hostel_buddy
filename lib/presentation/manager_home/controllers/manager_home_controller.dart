import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import 'dart:ui';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class ManagerHostel {
  ManagerHostel({
    required this.id,
    required this.name,
    required this.city,
    required this.type,
  });

  final String id;
  final String name;
  final String city;
  final String type;
}

class ManagerHomeController extends GetxController {
  final _box = GetStorage();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userName = 'there'.obs;
  final currentCity = 'Islamabad'.obs;

  /// All hostels owned by this manager
  final hostels = <ManagerHostel>[].obs;

  /// Currently selected hostel index
  final selectedHostelIndex = 0.obs;

  final totalRooms = 12.obs;
  final occupiedRooms = 8.obs;
  final pendingBids = 5.obs;
  final monthlyRevenue = '84k'.obs;

  final selectedNavIndex = 0.obs;

  final recentBids = <Map<String, dynamic>>[
    {
      'name': 'Ali Khan',
      'room': '2 Seater',
      'offer': 'Rs 11k',
      'status': 'Pending',
      'time': '2h ago',
    },
    {
      'name': 'Sara Ahmed',
      'room': '1 Seater',
      'offer': 'Rs 15k',
      'status': 'Pending',
      'time': '5h ago',
    },
    {
      'name': 'Hassan Raza',
      'room': '3 Seater',
      'offer': 'Rs 9k',
      'status': 'Accepted',
      'time': '1d ago',
    },
  ].obs;

  ManagerHostel? get currentHostel {
    if (hostels.isEmpty) return null;
    final i = selectedHostelIndex.value.clamp(0, hostels.length - 1);
    return hostels[i];
  }

  String get hostelName => currentHostel?.name ?? 'My Hostel';
  String get hostelType => currentHostel?.type ?? '';

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
    _loadHostels();
  }

  void _loadProfile() {
    final name = _box.read('profile_name')?.toString().trim();
    final city = _box.read('profile_city')?.toString().trim();
    if (name != null && name.isNotEmpty) {
      userName.value = name.split(' ').first;
    }
    if (city != null && city.isNotEmpty) {
      currentCity.value = city;
    }
  }

    void _loadHostels() {
    final stored = _box.read('manager_hostels');
    final hName = _box.read('hostel_name')?.toString().trim();
    final hType = _box.read('hostel_type')?.toString().trim() ?? '';
    final city =
        _box.read('profile_city')?.toString().trim() ?? currentCity.value;

    if (stored is List && stored.isNotEmpty) {
      hostels.assignAll(
        stored.map((e) {
          final m = Map<String, dynamic>.from(e as Map);
          return ManagerHostel(
            id: m['id']?.toString() ?? UniqueKey().toString(),
            name: m['name']?.toString() ?? 'Hostel',
            city: m['city']?.toString() ?? city,
            type: m['type']?.toString() ?? '',
          );
        }),
      );
    } else if (hName != null && hName.isNotEmpty) {
      hostels.assignAll([
        ManagerHostel(
          id: '1',
          name: hName,
          city: city,
          type: hType,
        ),
      ]);
      _persistHostels();
    } else {
      hostels.assignAll([
        ManagerHostel(
          id: '1',
          name: 'My Hostel',
          city: city,
          type: '',
        ),
      ]);
    }

    final savedIndex = _box.read('selected_hostel_index');
    if (savedIndex is int &&
        savedIndex >= 0 &&
        savedIndex < hostels.length) {
      selectedHostelIndex.value = savedIndex;
    } else {
      selectedHostelIndex.value = hostels.isEmpty ? 0 : hostels.length - 1;
    }
    _syncCityFromHostel();
  }
    void _persistHostels() {
    _box.write(
      'manager_hostels',
      hostels
          .map(
            (h) => {
              'id': h.id,
              'name': h.name,
              'city': h.city,
              'type': h.type,
            },
          )
          .toList(),
    );
    _box.write('selected_hostel_index', selectedHostelIndex.value);

    // Keep legacy keys in sync for other screens
    final h = currentHostel;
    if (h != null) {
      _box.write('hostel_name', h.name);
      _box.write('hostel_type', h.type);
    }
  }
  void _syncCityFromHostel() {
    final h = currentHostel;
    if (h != null && h.city.isNotEmpty) {
      currentCity.value = h.city;
    }
  }

  void selectHostel(int index) {
    if (index < 0 || index >= hostels.length) return;
    selectedHostelIndex.value = index;
    _syncCityFromHostel();
    _persistHostels();
  }

  void openDrawer() => scaffoldKey.currentState?.openEndDrawer();

  String get initials {
    final full = _box.read('profile_name')?.toString().trim() ?? userName.value;
    final parts = full.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  String get greeting {
    final h = DateTime.now().hour;
    if (h < 12) return 'Good Morning,';
    if (h < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }

  String get dateLabel {
    const months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec',
    ];
    final n = DateTime.now();
    return '${n.day} ${months[n.month - 1]} ${n.year}';
  }

  String get weekdayLabel {
    const days = [
      'Monday',
      'Tuesday',
      'Wednesday',
      'Thursday',
      'Friday',
      'Saturday',
      'Sunday',
    ];
    return days[DateTime.now().weekday - 1];
  }

  String get dayPart {
    final h = DateTime.now().hour;
    if (h >= 5 && h < 12) return 'Morning';
    if (h >= 12 && h < 17) return 'Afternoon';
    if (h >= 17 && h < 21) return 'Evening';
    return 'Night';
  }

  double get occupancyRate {
    if (totalRooms.value == 0) return 0;
    return occupiedRooms.value / totalRooms.value;
  }

  String get occupancyLabel =>
      '${occupiedRooms.value}/${totalRooms.value} rooms';

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        break;
      case 1:
        onViewBids();
        break;
      case 2:
        onManageRooms();
        break;
      case 3:
        onProfile();
        break;
    }
  }

  void onNotifications() => Get.toNamed(AppRoutes.notifications);

  void onProfile() => Get.toNamed(AppRoutes.profile);

  void onViewBids() => Get.toNamed(AppRoutes.managerIncomingBids);

  void onManageRooms() =>
      AppSnackbar.info('Rooms', 'Room management coming next.');

   void onEditListing() {
    final h = currentHostel;
    if (h == null) {
      AppSnackbar.info('No hostel', 'Add a hostel first.');
      return;
    }

    // Controllers pre-filled from current hostel + storage
    final nameCtrl = TextEditingController(text: h.name);
    final cityCtrl = TextEditingController(text: h.city);
    final typeCtrl = TextEditingController(
      text: h.type.isNotEmpty
          ? h.type
          : (_box.read('hostel_type')?.toString() ?? ''),
    );
    final contactCtrl = TextEditingController(
      text: _box.read('profile_phone')?.toString() ?? '',
    );
    final areaCtrl = TextEditingController(
      text: _box.read('hostel_area')?.toString() ?? '',
    );
    final descCtrl = TextEditingController(
      text: _box.read('hostel_description')?.toString() ?? '',
    );
    final roomsCtrl = TextEditingController(
      text: '${totalRooms.value}',
    );

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.5),
      Container(
        constraints: BoxConstraints(
          maxHeight: MediaQuery.of(Get.context!).size.height * 0.88,
        ),
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              Color(0xFF4A0A1E),
              Color(0xFF2A0412),
              Color(0xFF1A020C),
            ],
          ),
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // Handle
            const SizedBox(height: 10),
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.25),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            // Title row
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 16, 12, 8),
              child: Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    decoration: BoxDecoration(
                      color: AppColors.accent.withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.edit_outlined,
                      color: AppColors.accentLight,
                      size: 22,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Edit hostel',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        Text(
                          'Update your listing details',
                          style: TextStyle(
                            color: Colors.white54,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    onPressed: () => Get.back(),
                    icon: Icon(
                      Icons.close_rounded,
                      color: Colors.white.withValues(alpha: 0.6),
                    ),
                  ),
                ],
              ),
            ),
            Divider(color: Colors.white.withValues(alpha: 0.08), height: 1),

            // Form
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 24),
                physics: const BouncingScrollPhysics(),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _sheetLabel('Hostel name'),
                    _sheetField(nameCtrl, Icons.home_rounded, 'Hostel name'),
                    const SizedBox(height: 14),
                    _sheetLabel('City'),
                    _sheetField(cityCtrl, Icons.location_city_rounded, 'City'),
                    const SizedBox(height: 14),
                    _sheetLabel('Area'),
                    _sheetField(areaCtrl, Icons.map_rounded, 'Area / locality'),
                    const SizedBox(height: 14),
                    _sheetLabel('Hostel type'),
                    _sheetField(
                      typeCtrl,
                      Icons.people_rounded,
                      'Boys / Girls Hostel',
                    ),
                    const SizedBox(height: 14),
                    _sheetLabel('Contact'),
                    _sheetField(
                      contactCtrl,
                      Icons.phone_rounded,
                      'Phone number',
                      keyboard: TextInputType.phone,
                    ),
                    const SizedBox(height: 14),
                    _sheetLabel('Total rooms'),
                    _sheetField(
                      roomsCtrl,
                      Icons.meeting_room_rounded,
                      'Rooms',
                      keyboard: TextInputType.number,
                    ),
                    const SizedBox(height: 14),
                    _sheetLabel('Description'),
                    _sheetField(
                      descCtrl,
                      Icons.notes_rounded,
                      'Short description',
                      maxLines: 3,
                    ),
                    const SizedBox(height: 24),

                    // Save
                    SizedBox(
                      width: double.infinity,
                      height: 52,
                      child: ElevatedButton(
                        onPressed: () {
                          final name = nameCtrl.text.trim();
                          final city = cityCtrl.text.trim();
                          if (name.isEmpty) {
                            AppSnackbar.warning(
                              'Name',
                              'Hostel name is required.',
                            );
                            return;
                          }

                          // Update in-memory list
                          final idx = selectedHostelIndex.value;
                          if (idx >= 0 && idx < hostels.length) {
                            hostels[idx] = ManagerHostel(
                              id: hostels[idx].id,
                              name: name,
                              city: city.isNotEmpty ? city : hostels[idx].city,
                              type: typeCtrl.text.trim(),
                            );
                            hostels.refresh();
                          }

                          // Persist
                          _box.write('hostel_name', name);
                          _box.write('hostel_type', typeCtrl.text.trim());
                          _box.write('hostel_area', areaCtrl.text.trim());
                          _box.write(
                            'hostel_description',
                            descCtrl.text.trim(),
                          );
                          final rooms = int.tryParse(roomsCtrl.text.trim());
                          if (rooms != null && rooms > 0) {
                            totalRooms.value = rooms;
                          }
                          _persistHostels();
                          _syncCityFromHostel();

                          Get.back();
                          AppSnackbar.success(
                            'Updated',
                            '$name has been saved.',
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                        ),
                        child: const Text(
                          'Save changes',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(Get.context!).padding.bottom + 8,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _sheetLabel(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white.withValues(alpha: 0.55),
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Widget _sheetField(
    TextEditingController ctrl,
    IconData icon,
    String hint, {
    TextInputType keyboard = TextInputType.text,
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      keyboardType: keyboard,
      maxLines: maxLines,
      style: const TextStyle(
        color: Colors.white,
        fontSize: 14.5,
        fontWeight: FontWeight.w600,
      ),
      cursorColor: AppColors.accentLight,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: TextStyle(
          color: Colors.white.withValues(alpha: 0.3),
          fontSize: 14,
        ),
        prefixIcon: Icon(
          icon,
          color: AppColors.accentLight.withValues(alpha: 0.8),
          size: 20,
        ),
        filled: true,
        fillColor: Colors.white.withValues(alpha: 0.07),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 14,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: BorderSide(color: Colors.white.withValues(alpha: 0.12)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: AppColors.accent, width: 1.4),
        ),
      ),
    );
  }

  void onAddListing() => Get.toNamed(AppRoutes.hostelSetup);

  void onBidTap(Map<String, dynamic> bid) {
    Get.toNamed(AppRoutes.managerIncomingBids);
  }

  void onSettings() => AppSnackbar.info('Settings', 'Settings coming next.');

  void onLogout() {
    AppSnackbar.info('Logged out', 'Session ended.');
    Get.offAllNamed(AppRoutes.auth);
  }

  // ── Hostel switch / add ──

  /// Header dropdown or drawer "Switch hostel"
  void onSwitchHostel() {
    if (hostels.length <= 1) {
      _showAddHostelDialog();
    } else {
      onHostelDropdown();
    }
  }

  void _showAddHostelDialog() {
    Get.dialog(
      barrierDismissible: true,
      barrierColor: Colors.black.withValues(alpha: 0.55),
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
            child: Container(
              padding: const EdgeInsets.fromLTRB(24, 28, 24, 20),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withValues(alpha: 0.12),
                    Colors.white.withValues(alpha: 0.04),
                  ],
                ),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.18)),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 28,
                    spreadRadius: 2,
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
                      color: AppColors.accent.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.accent.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.add_home_rounded,
                      size: 28,
                      color: AppColors.accentLight,
                    ),
                  ),
                  const SizedBox(height: 18),
                  const Text(
                    'Add another hostel?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'You only have one hostel listed. Would you like to add another?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white.withValues(alpha: 0.6),
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
                              foregroundColor: Colors.white,
                              side: BorderSide(
                                color: Colors.white.withValues(alpha: 0.25),
                              ),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'No',
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
                              onAddListing();
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
                              'Yes',
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
        ),
      ),
    );
  }

  void _showHostelPicker() {
    Get.bottomSheet(
      Container(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 28),
        decoration: const BoxDecoration(
          color: Color(0xFF2A0412),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.25),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const Text(
              'Your hostels',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.w800,
              ),
            ),
            const SizedBox(height: 14),
            Obx(
              () => Column(
                children: List.generate(hostels.length, (i) {
                  final h = hostels[i];
                  final selected = selectedHostelIndex.value == i;
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Material(
                      color: Colors.transparent,
                      child: InkWell(
                        onTap: () {
                          selectHostel(i);
                          Get.back();
                        },
                        borderRadius: BorderRadius.circular(14),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 12,
                          ),
                          decoration: BoxDecoration(
                            color: selected
                                ? AppColors.accent.withValues(alpha: 0.2)
                                : Colors.white.withValues(alpha: 0.06),
                            borderRadius: BorderRadius.circular(14),
                            border: Border.all(
                              color: selected
                                  ? AppColors.accent.withValues(alpha: 0.6)
                                  : Colors.white.withValues(alpha: 0.1),
                            ),
                          ),
                          child: Row(
                            children: [
                              Icon(
                                Icons.home_rounded,
                                color: selected
                                    ? AppColors.accentLight
                                    : Colors.white70,
                                size: 22,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      h.name,
                                      style: const TextStyle(
                                        color: Colors.white,
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                    Text(
                                      h.city,
                                      style: TextStyle(
                                        color: Colors.white.withValues(
                                          alpha: 0.5,
                                        ),
                                        fontSize: 12,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (selected)
                                const Icon(
                                  Icons.check_circle_rounded,
                                  color: AppColors.accentLight,
                                  size: 22,
                                ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 8),
            SizedBox(
              width: double.infinity,
              height: 48,
              child: OutlinedButton.icon(
                onPressed: () {
                  Get.back();
                  onAddListing();
                },
                icon: const Icon(Icons.add_rounded, size: 20),
                label: const Text(
                  'Add hostel',
                  style: TextStyle(fontWeight: FontWeight.w700),
                ),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.accentLight,
                  side: BorderSide(
                    color: AppColors.accent.withValues(alpha: 0.5),
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      isScrollControlled: true,
    );
  }

  /// Called from header dropdown: show picker always (with Add hostel)
  void onHostelDropdown() {
    final context = Get.context;
    if (context == null) return;

    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Switch hostel',
      barrierColor: Colors.black.withValues(alpha: 0.4),
      transitionDuration: const Duration(milliseconds: 180),
      pageBuilder: (_, __, ___) {
        return SafeArea(
          child: Align(
            alignment: Alignment.topCenter,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(48, 52, 48, 0),
              child: Material(
                color: Colors.transparent,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(18),
                  child: BackdropFilter(
                    filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                    child: Container(
                      constraints: const BoxConstraints(maxWidth: 280),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [
                            Colors.white.withValues(alpha: 0.16),
                            Colors.white.withValues(alpha: 0.06),
                          ],
                        ),
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.2),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 24,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Header
                          Padding(
                            padding: const EdgeInsets.fromLTRB(14, 12, 14, 8),
                            child: Text(
                              'SWITCH HOSTEL',
                              style: TextStyle(
                                color: Colors.white.withValues(alpha: 0.45),
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                letterSpacing: 1.0,
                              ),
                            ),
                          ),
                          Divider(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),

                          // Hostel list
                          Obx(
                            () => Column(
                              children: List.generate(hostels.length, (i) {
                                final h = hostels[i];
                                final selected = selectedHostelIndex.value == i;
                                return InkWell(
                                  onTap: () {
                                    selectHostel(i);
                                    Get.back();
                                  },
                                  child: Container(
                                    margin: const EdgeInsets.fromLTRB(
                                      8,
                                      6,
                                      8,
                                      2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 10,
                                      vertical: 9,
                                    ),
                                    decoration: BoxDecoration(
                                      color: selected
                                          ? AppColors.accent.withValues(
                                              alpha: 0.22,
                                            )
                                          : Colors.transparent,
                                      borderRadius: BorderRadius.circular(12),
                                      border: selected
                                          ? Border.all(
                                              color: AppColors.accent
                                                  .withValues(alpha: 0.45),
                                            )
                                          : null,
                                    ),
                                    child: Row(
                                      children: [
                                        Container(
                                          width: 32,
                                          height: 32,
                                          decoration: BoxDecoration(
                                            color: selected
                                                ? AppColors.accent.withValues(
                                                    alpha: 0.3,
                                                  )
                                                : Colors.white.withValues(
                                                    alpha: 0.08,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              10,
                                            ),
                                          ),
                                          child: Icon(
                                            Icons.home_rounded,
                                            color: selected
                                                ? AppColors.accentLight
                                                : Colors.white.withValues(
                                                    alpha: 0.6,
                                                  ),
                                            size: 18,
                                          ),
                                        ),
                                        const SizedBox(width: 10),
                                        Expanded(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                h.name,
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 13,
                                                  fontWeight: selected
                                                      ? FontWeight.w700
                                                      : FontWeight.w600,
                                                ),
                                              ),
                                              Text(
                                                h.city,
                                                style: TextStyle(
                                                  color: Colors.white
                                                      .withValues(alpha: 0.5),
                                                  fontSize: 11,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        if (selected)
                                          const Icon(
                                            Icons.check_circle_rounded,
                                            color: AppColors.accentLight,
                                            size: 18,
                                          ),
                                      ],
                                    ),
                                  ),
                                );
                              }),
                            ),
                          ),

                          Divider(
                            height: 1,
                            color: Colors.white.withValues(alpha: 0.1),
                          ),

                          // Add hostel
                          InkWell(
                            onTap: () {
                              Get.back();
                              onAddListing();
                            },
                            borderRadius: const BorderRadius.vertical(
                              bottom: Radius.circular(18),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(
                                14,
                                10,
                                14,
                                12,
                              ),
                              child: Row(
                                children: [
                                  Container(
                                    width: 32,
                                    height: 32,
                                    decoration: BoxDecoration(
                                      color: AppColors.accent.withValues(
                                        alpha: 0.15,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: const Icon(
                                      Icons.add_home_rounded,
                                      color: AppColors.accentLight,
                                      size: 18,
                                    ),
                                  ),
                                  const SizedBox(width: 10),
                                  const Expanded(
                                    child: Text(
                                      'Add hostel',
                                      style: TextStyle(
                                        color: AppColors.accentLight,
                                        fontSize: 13,
                                        fontWeight: FontWeight.w700,
                                      ),
                                    ),
                                  ),
                                  Icon(
                                    Icons.chevron_right_rounded,
                                    color: Colors.white.withValues(alpha: 0.35),
                                    size: 18,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return FadeTransition(
          opacity: anim,
          child: ScaleTransition(
            scale: Tween<double>(begin: 0.94, end: 1).animate(
              CurvedAnimation(parent: anim, curve: Curves.easeOutCubic),
            ),
            child: child,
          ),
        );
      },
    );
  }
}
