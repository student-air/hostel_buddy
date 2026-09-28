import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class IncomingBid {
  IncomingBid({
    required this.id,
    required this.seekerName,
    required this.seater,
    required this.offer,
    required this.amenities,
    required this.time,
    required this.status, // pending | accepted | rejected
  });

  final String id;
  final String seekerName;
  final String seater;
  final String offer;
  final List<String> amenities;
  final String time;
  String status;

  String get initials {
    final parts = seekerName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }
}

class ManagerIncomingBidsController extends GetxController {
  final selectedTab = 0.obs; // 0 All, 1 Pending, 2 Accepted, 3 Rejected
  final selectedNavIndex = 1.obs;
  final searchQuery = ''.obs;

  final bids = <IncomingBid>[
    IncomingBid(
      id: '1',
      seekerName: 'Ali Khan',
      seater: '2 Seater',
      offer: 'Rs 11,000/mo',
      amenities: ['Wifi', 'AC', 'Laundry'],
      time: '2h ago',
      status: 'pending',
    ),
    IncomingBid(
      id: '2',
      seekerName: 'Sara Ahmed',
      seater: '1 Seater',
      offer: 'Rs 15,000/mo',
      amenities: ['Wifi', 'Furnished', 'Geyser'],
      time: '5h ago',
      status: 'pending',
    ),
    IncomingBid(
      id: '3',
      seekerName: 'Hassan Raza',
      seater: '3 Seater',
      offer: 'Rs 9,000/mo',
      amenities: ['Wifi', 'Mess'],
      time: '1d ago',
      status: 'accepted',
    ),
    IncomingBid(
      id: '4',
      seekerName: 'Fatima Noor',
      seater: '2 Seater',
      offer: 'Rs 10,500/mo',
      amenities: ['Wifi', 'AC', 'Parking'],
      time: '2d ago',
      status: 'rejected',
    ),
  ].obs;

  List<IncomingBid> get filtered {
    var list = bids.toList();
    switch (selectedTab.value) {
      case 1:
        list = list.where((b) => b.status == 'pending').toList();
        break;
      case 2:
        list = list.where((b) => b.status == 'accepted').toList();
        break;
      case 3:
        list = list.where((b) => b.status == 'rejected').toList();
        break;
    }
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where((b) =>
              b.seekerName.toLowerCase().contains(q) ||
              b.seater.toLowerCase().contains(q) ||
              b.offer.toLowerCase().contains(q))
          .toList();
    }
    return list;
  }

  void onTabChanged(int i) => selectedTab.value = i;
  void onSearchChanged(String q) => searchQuery.value = q;

  void acceptBid(IncomingBid bid) {
    bid.status = 'accepted';
    bids.refresh();
    AppSnackbar.success('Accepted', 'Offer sent to ${bid.seekerName}');
  }

  void rejectBid(IncomingBid bid) {
    bid.status = 'rejected';
    bids.refresh();
    AppSnackbar.info('Rejected', 'Bid from ${bid.seekerName} declined');
  }

  void onNavTap(int index) {
    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.managerHome);
        break;
      case 1:
        break; // already here
      case 2:
        AppSnackbar.info('Rooms', 'Room management coming next.');
        break;
      case 3:
        AppSnackbar.info('Chat', 'Chat coming next.');
        break;
      case 4:
        Get.toNamed(AppRoutes.profile);
        break;
    }
  }
}