import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SeekerMapController extends GetxController {
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;
  final selectedHostel = Rxn<Map<String, dynamic>>();

  final filters = ['All', 'Nearby', 'Under 30k', 'Shared', 'Private'];

  final hostels = <Map<String, dynamic>>[
    {
      'name': 'Green Valley Hostel',
      'area': 'G-9',
      'city': 'Islamabad',
      'distance': '1.2 km',
      'price': 'Rs 12k/mo',
      'rating': 4.6,
    },
    {
      'name': 'Campus View Lodge',
      'area': 'I-8',
      'city': 'Islamabad',
      'distance': '2.4 km',
      'price': 'Rs 9.5k/mo',
      'rating': 4.3,
    },
    {
      'name': 'Scholar Nest',
      'area': 'F-7',
      'city': 'Islamabad',
      'distance': '3.1 km',
      'price': 'Rs 14k/mo',
      'rating': 4.8,
    },
    {
      'name': 'Al-Haram Hostel',
      'area': 'G-11',
      'city': 'Islamabad',
      'distance': '1.8 km',
      'price': 'Rs 11k/mo',
      'rating': 4.4,
    },
  ].obs;

  List<Map<String, dynamic>> get filtered {
    var list = hostels.toList();
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list.where((h) {
        final name = (h['name'] ?? '').toString().toLowerCase();
        final area = (h['area'] ?? '').toString().toLowerCase();
        return name.contains(q) || area.contains(q);
      }).toList();
    }
    if (selectedFilter.value == 'Under 30k') {
      list = list.where((h) {
        final p = (h['price'] ?? '').toString();
        return p.contains('9') || p.contains('8') || p.contains('7');
      }).toList();
    }
    return list;
  }

  void onFilterChanged(String f) => selectedFilter.value = f;

  void onSearchChanged(String q) => searchQuery.value = q;

  void onHostelTap(Map<String, dynamic> h) {
    selectedHostel.value = h;
    AppSnackbar.info(
      h['name']?.toString() ?? 'Hostel',
      'Details coming next.',
    );
  }

  void onNavTap(int index) {
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.seekerHome);
        break;
      case 1:
        Get.toNamed(AppRoutes.seekerBids);
        break;
      case 2:
        Get.toNamed(AppRoutes.seekerSearch);
        break;
      case 3:
        Get.toNamed(AppRoutes.profile);
        break;
    }
  }
}