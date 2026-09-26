import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';

class SeekerHomeController extends GetxController {
  final userName = 'Ayesha'.obs;
  final userRoleLabel = 'Student · Finding a hostel'.obs;
  final currentCity = 'Islamabad'.obs;

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

  String get initials {
    final parts = userName.value.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  get isLoadingHostels => null;

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
    AppSnackbar.info(hostel['name'] as String, 'Details coming next.');
  }

  void onOtherCities() =>
      AppSnackbar.info('Cities', 'City picker coming next.');
}
