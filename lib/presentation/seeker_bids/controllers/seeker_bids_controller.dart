import 'package:get/get.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class BidItem {
  BidItem({
    required this.id,
    required this.hostelName,
    required this.initials,
    required this.location,
    required this.offeredPrice,
    required this.yourBid,
    required this.phone,
    required this.roomType,
    required this.seater,
    this.isActive = true,
    this.overallRating,
  });

  final String id;
  final String hostelName;
  final String initials;
  final String location;
  final String offeredPrice;
  final String yourBid;
  final String phone;
  final String roomType;
  final String seater;
  final bool isActive;
  double? overallRating; // ← added
}

class SeekerBidsController extends GetxController {
  final selectedTab = 0.obs;
  final selectedNavIndex = 1.obs;
  final coins = 500.obs;

  final reviewRatings = <String, double>{
    'Cleanliness': 0,
    'Staff': 0,
    'Value': 0,
    'Location': 0,
    'Amenities': 0,
  }.obs;
  final reviewText = ''.obs;

  double get overallRating {
    final values = reviewRatings.values.where((v) => v > 0).toList();
    if (values.isEmpty) return 0;
    return values.reduce((a, b) => a + b) / values.length;
  }

  final received = <BidItem>[
    BidItem(
      id: 'r1',
      hostelName: 'Green Valley Hostel',
      initials: 'GV',
      location: 'G-9, Islamabad',
      offeredPrice: 'Rs 11,500/mo',
      yourBid: 'Rs 10,000/mo',
      phone: '+923001234567',
      roomType: 'Shared',
      seater: '2-seater',
    ),
    BidItem(
      id: 'r2',
      hostelName: 'Campus View Lodge',
      initials: 'CV',
      location: 'I-8, Islamabad',
      offeredPrice: 'Rs 9,200/mo',
      yourBid: 'Rs 8,500/mo',
      phone: '+923009876543',
      roomType: 'Private',
      seater: '1-seater',
    ),
  ].obs;

  final pending = <BidItem>[].obs;
  final closed = <BidItem>[].obs;

  void onTabChanged(int index) => selectedTab.value = index;

  void onNavTap(int index) {
  selectedNavIndex.value = index;
  switch (index) {
    case 0:
      Get.offAllNamed(AppRoutes.seekerHome);
      break;
    case 1:
      break; // already on Bids
    case 2:
      Get.toNamed(AppRoutes.seekerSearch); // ← Search
      break;
    case 3:
      Get.toNamed(AppRoutes.profile);
      break;
  }
}

  void onContinue(BidItem item) {
    if (coins.value < 100) {
      AppSnackbar.error('Not enough coins', 'You need 100 coins to continue.');
      return;
    }
    coins.value -= 100;
    received.removeWhere((e) => e.id == item.id);
    pending.add(item);
    selectedTab.value = 1;
    Get.back();
    AppSnackbar.success('Moved to Pending', '100 coins used.');
  }

  void onAccept(BidItem item) {
    pending.removeWhere((e) => e.id == item.id);
    closed.add(item);
    selectedTab.value = 2;
    AppSnackbar.success('Accepted', 'Bid moved to Closed.');
  }

  void onReject(BidItem item) {
    pending.removeWhere((e) => e.id == item.id);
    AppSnackbar.info('Rejected', 'Offer removed.');
  }

  void onCall(String phone) {
    AppSnackbar.info('Calling', phone);
  }

  void setRating(String category, double value) {
    reviewRatings[category] = value;
    reviewRatings.refresh();
  }

  void submitReview(BidItem item) {
  final hasRating = reviewRatings.values.any((v) => v > 0);
  if (!hasRating) {
    AppSnackbar.warning('Rate at least one', 'Please give a star rating.');
    return;
  }

  // Save overall rating on the closed item
  final index = closed.indexWhere((e) => e.id == item.id);
  if (index != -1) {
    closed[index].overallRating = overallRating;
    closed.refresh();
  }

  Get.back();
  AppSnackbar.success(
    'Review submitted',
    'Thanks for reviewing ${item.hostelName}! Overall ${overallRating.toStringAsFixed(1)}',
  );
}

  void resetReview() {
    reviewRatings.updateAll((key, value) => 0);
    reviewRatings.refresh();
    reviewText.value = '';
  }
}