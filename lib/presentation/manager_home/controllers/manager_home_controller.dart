import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class ManagerHomeController extends GetxController {
  final _box = GetStorage();

  final scaffoldKey = GlobalKey<ScaffoldState>();

  final userName = 'there'.obs;
  final hostelName = 'My Hostel'.obs;
  final hostelType = ''.obs;
  final currentCity = 'Islamabad'.obs;

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

  @override
  void onInit() {
    super.onInit();
    _loadProfile();
  }

  void _loadProfile() {
    final name = _box.read('profile_name')?.toString().trim();
    final city = _box.read('profile_city')?.toString().trim();
    final hName = _box.read('hostel_name')?.toString().trim();
    final hType = _box.read('hostel_type')?.toString().trim();

    if (name != null && name.isNotEmpty) {
      userName.value = name.split(' ').first;
    }
    if (city != null && city.isNotEmpty) {
      currentCity.value = city;
    }
    if (hName != null && hName.isNotEmpty) {
      hostelName.value = hName;
    }
    if (hType != null && hType.isNotEmpty) {
      hostelType.value = hType;
    }
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
        onMessages();
        break;
      case 4:
        onProfile();
        break;
    }
  }

  void onNotifications() => Get.toNamed(AppRoutes.notifications);

  void onProfile() => Get.toNamed(AppRoutes.profile);

  void onViewBids() => AppSnackbar.info('Bids', 'All bids coming next.');

  void onManageRooms() =>
      AppSnackbar.info('Rooms', 'Room management coming next.');

  void onMessages() => AppSnackbar.info('Messages', 'Chat coming next.');

  void onEditListing() =>
      AppSnackbar.info('Listing', 'Edit hostel coming next.');

  void onAddListing() => Get.toNamed(AppRoutes.hostelSetup);

  void onBidTap(Map<String, dynamic> bid) {
    final name = bid['name']?.toString() ?? 'Bid';
    AppSnackbar.info(name, 'Bid detail coming next.');
  }

  void onSettings() => AppSnackbar.info('Settings', 'Settings coming next.');

  void onLogout() {
    AppSnackbar.info('Logged out', 'Session ended.');
    Get.offAllNamed(AppRoutes.auth);
  }
}
