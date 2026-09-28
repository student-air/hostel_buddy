import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SeekerHomeController extends GetxController {
  final _box = GetStorage();

  /// Stable key for endDrawer — do not create in build()
  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userName = 'there'.obs;
  final userRoleLabel = 'Finding a hostel'.obs;
  final currentCity = 'Islamabad'.obs;
  final occupation = 'student'.obs;

  final pendingBids = 2.obs;
  final acceptedBids = 1.obs;
  final avgOffer = '11k'.obs;

  final selectedNavIndex = 0.obs;

  final hostels = <Map<String, dynamic>>[
    {
      'name': 'Green Valley Hostel',
      'area': 'G-9',
      'city': 'Islamabad',
      'distance': '1.2 km',
      'price': 'Rs 12k/mo',
      'rating': 4.6,
      'color': 0xFF8B1538,
    },
    {
      'name': 'Campus View Lodge',
      'area': 'I-8',
      'city': 'Islamabad',
      'distance': '2.4 km',
      'price': 'Rs 9.5k/mo',
      'rating': 4.3,
      'color': 0xFF0D9488,
    },
    {
      'name': 'Scholar Nest',
      'area': 'F-7',
      'city': 'Islamabad',
      'distance': '3.1 km',
      'price': 'Rs 14k/mo',
      'rating': 4.8,
      'color': 0xFF5C0E24,
    },
  ].obs;

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() {
    final name = _box.read('profile_name')?.toString().trim();
    final city = _box.read('profile_city')?.toString().trim();
    final occ = _box.read('profile_occupation')?.toString().trim();

    if (name != null && name.isNotEmpty) {
      userName.value = name.split(' ').first;
    }
    if (city != null && city.isNotEmpty) {
      currentCity.value = city;
    }
    if (occ != null && occ.isNotEmpty) {
      occupation.value = occ;
    }
    // Always plain label — no "Student ·"
    userRoleLabel.value = 'Finding a hostel';
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

  void onNavTap(int index) {
  selectedNavIndex.value = index;
  switch (index) {
    case 0:
      break; // already on Home
    case 1:
      Get.toNamed(AppRoutes.seekerBids);
      break;
    case 2:
      Get.toNamed(AppRoutes.seekerSearch); // ← Search
      break;
    case 3:
      Get.toNamed(AppRoutes.profile);
      break;
  }
} 

  void onOtherCities() {
  final cities = [
    'Islamabad',
    'Rawalpindi',
    'Lahore',
    'Karachi',
    'Faisalabad',
    'Multan',
    'Peshawar',
    'Quetta',
    'Sialkot',
    'Gujranwala',
    'Hyderabad',
    'Abbottabad',
  ];

  Get.bottomSheet(
    isScrollControlled: true,
    Container(
      constraints: BoxConstraints(
        maxHeight: Get.height * 0.65,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF2A0412),
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.25),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 22),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Select city',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 22),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                'Hostels will update for the selected city',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.45),
                  fontSize: 13,
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          Flexible(
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
              shrinkWrap: true,
              itemCount: cities.length,
              separatorBuilder: (_, __) => const SizedBox(height: 6),
              itemBuilder: (_, i) {
                final city = cities[i];
                return Obx(() {
                  final selected = currentCity.value == city;
                  return GestureDetector(
                    onTap: () {
                      currentCity.value = city;
                      _box.write('profile_city', city);
                      Get.back();
                      AppSnackbar.success(
                        'City updated',
                        'Showing hostels in $city',
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent.withValues(alpha: 0.2)
                            : Colors.white.withValues(alpha: 0.05),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? AppColors.accent
                              : Colors.white.withValues(alpha: 0.1),
                        ),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            selected
                                ? Icons.location_on_rounded
                                : Icons.location_on_outlined,
                            size: 20,
                            color: selected
                                ? AppColors.accentLight
                                : Colors.white.withValues(alpha: 0.5),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              city,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 15,
                                fontWeight: selected
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                              ),
                            ),
                          ),
                          if (selected)
                            const Icon(
                              Icons.check_circle_rounded,
                              size: 20,
                              color: AppColors.accentLight,
                            ),
                        ],
                      ),
                    ),
                  );
                });
              },
            ),
          ),
        ],
      ),
    ),
  );
}

  void onHome() => Get.toNamed(AppRoutes.seekerHome);

  void onCreateBid() => Get.toNamed(AppRoutes.placeBid);

  void onMyBids() => Get.toNamed(AppRoutes.seekerMyBids);

  void onMapView() => Get.toNamed(AppRoutes.seekerMap);


  void onSearch() => Get.toNamed(AppRoutes.seekerSearch);

  void onNotifications() => Get.toNamed(AppRoutes.notifications);

  void onViewAllBids() => Get.toNamed(AppRoutes.seekerBids);

  void onSeeAllHostels() =>
      AppSnackbar.info('Hostels', 'Full list coming next.');

  void onHostelTap(Map<String, dynamic> hostel) {
    final name = hostel['name']?.toString() ?? 'Hostel';
    AppSnackbar.info(name, 'Details coming next.');
  }

  

  void onProfile() => Get.toNamed(AppRoutes.profile);

  void onChat() => AppSnackbar.info('Chat', 'Chat coming next.');

  void onSettings() => AppSnackbar.info('Settings', 'Settings coming next.');

  void onLogout() {
    Get.dialog(
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
                  // Icon
                  Container(
                    width: 64,
                    height: 64,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.error.withValues(alpha: 0.15),
                      border: Border.all(
                        color: AppColors.error.withValues(alpha: 0.4),
                      ),
                    ),
                    child: const Icon(
                      Icons.logout_rounded,
                      size: 28,
                      color: AppColors.error,
                    ),
                  ),
                  const SizedBox(height: 18),

                  // Title
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

                  // Subtitle
                  Text(
                    'Are you sure you want to log out of Hostel Buddy?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: AppColors.accentLight.withValues(alpha: 0.85),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 28),

                  // Buttons
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
        ),
      ),
    );
  }
}
