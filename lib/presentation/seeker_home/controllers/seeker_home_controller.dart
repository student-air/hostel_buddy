import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

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
    if (index != 0) {
      AppSnackbar.info('Coming soon', 'This tab will open next.');
    }
  }

  void onCreateBid() => AppSnackbar.info('Create bid', 'Bid flow coming next.');

  void onMapView() => AppSnackbar.info('Map', 'Map view coming next.');

  void onSaved() => AppSnackbar.info('Saved', 'Saved hostels coming next.');

  void onNotifications() => AppSnackbar.info('Alerts', 'No new notifications.');

  void onViewAllBids() =>
      AppSnackbar.info('Bids', 'Full bids list coming next.');

  void onSeeAllHostels() =>
      AppSnackbar.info('Hostels', 'Full list coming next.');

  void onHostelTap(Map<String, dynamic> hostel) {
    final name = hostel['name']?.toString() ?? 'Hostel';
    AppSnackbar.info(name, 'Details coming next.');
  }

  void onOtherCities() =>
      AppSnackbar.info('Cities', 'City picker coming next.');

  void onProfile() => Get.toNamed(AppRoutes.profile);

  void onChat() => AppSnackbar.info('Chat', 'Chat coming next.');

  void onSettings() => AppSnackbar.info('Settings', 'Settings coming next.');

  void onLogout() {
    AppSnackbar.info('Logged out', 'Session ended.');
    Get.offAllNamed(AppRoutes.auth);
  }
}
