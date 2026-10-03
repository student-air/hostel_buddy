import 'package:get/get.dart';
// import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SeekerSearchController extends GetxController {
  final selectedNavIndex = 2.obs; // Search tab
  final searchQuery = ''.obs;
  final selectedFilter = 'All'.obs;

  final filters = ['All', 'Shared', 'Private', '2-seater', '1-seater'];

  final hostels = <Map<String, dynamic>>[
    {
      'name': 'Green Valley Hostel',
      'area': 'G-9',
      'city': 'Islamabad',
      'distance': '1.2 km',
      'price': 'Rs 12k/mo',
      'rating': 4.6,
      'seater': '2-seater',
      'type': 'Shared',
      'color': 0xFF8B1538,
    },
    {
      'name': 'Campus View Lodge',
      'area': 'I-8',
      'city': 'Islamabad',
      'distance': '2.4 km',
      'price': 'Rs 9.5k/mo',
      'rating': 4.3,
      'seater': '1-seater',
      'type': 'Private',
      'color': 0xFF0D9488,
    },
    {
      'name': 'Scholar Nest',
      'area': 'F-7',
      'city': 'Islamabad',
      'distance': '3.1 km',
      'price': 'Rs 14k/mo',
      'rating': 4.8,
      'seater': '2-seater',
      'type': 'Shared',
      'color': 0xFF5C0E24,
    },
    {
      'name': 'Al-Haram Hostel',
      'area': 'G-11',
      'city': 'Islamabad',
      'distance': '1.8 km',
      'price': 'Rs 11k/mo',
      'rating': 4.4,
      'seater': '3-seater',
      'type': 'Shared',
      'color': 0xFF6B0E24,
    },
  ].obs;

  List<Map<String, dynamic>> get filteredHostels {
    var list = hostels.toList();
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((h) {
        final name = (h['name'] ?? '').toString().toLowerCase();
        final area = (h['area'] ?? '').toString().toLowerCase();
        return name.contains(q) || area.contains(q);
      }).toList();
    }
    final f = selectedFilter.value;
    if (f != 'All') {
      list = list.where((h) {
        return (h['type'] ?? '') == f || (h['seater'] ?? '') == f;
      }).toList();
    }
    return list;
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.seekerHome);
        break;
      case 1:
        Get.toNamed(AppRoutes.seekerBids);
        break;
      case 2:
        break;
      case 3:
        Get.toNamed(AppRoutes.profile);
        break;
    }
  }

  void onHostelTap(Map<String, dynamic> hostel) {
  Get.toNamed(AppRoutes.hostelDetails, arguments: hostel);
}
}