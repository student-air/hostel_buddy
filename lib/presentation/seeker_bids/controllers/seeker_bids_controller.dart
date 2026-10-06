import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_colors.dart';
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
  double? overallRating;
}

class MyBidItem {
  MyBidItem({
    required this.id,
    required this.seater,
    required this.amenities,
    required this.yourOffer,
    required this.status,
    required this.createdAt,
    this.location = '',
    this.hostelType = 'Boys Hostel',
    this.offerAmount = 15000,
    this.endsIn = '24h',
  });

  final String id;
  final String seater;
  final List<String> amenities;
  final String yourOffer;
  final String status;
  final String createdAt;
  final String location;
  final String hostelType;
  final int offerAmount;
  final String endsIn;

  factory MyBidItem.fromMap(Map<String, dynamic> map) {
    return MyBidItem(
      id: map['id']?.toString() ?? '',
      seater: map['seater']?.toString() ?? '',
      amenities: List<String>.from(map['amenities'] ?? []),
      yourOffer: map['yourOffer']?.toString() ?? '',
      status: map['status']?.toString() ?? 'pending',
      createdAt: map['createdAt']?.toString() ?? '',
      location: map['location']?.toString() ?? '',
      hostelType: map['hostelType']?.toString() ?? 'Boys Hostel',
      offerAmount: (map['offerAmount'] as num?)?.toInt() ?? 15000,
      endsIn: map['endsIn']?.toString() ?? '24h',
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'seater': seater,
        'amenities': amenities,
        'yourOffer': yourOffer,
        'status': status,
        'createdAt': createdAt,
        'location': location,
        'hostelType': hostelType,
        'offerAmount': offerAmount,
        'endsIn': endsIn,
      };

  String get statusLabel {
    switch (status) {
      case 'pending':
        return 'Pending';
      case 'responded':
        return 'Responded';
      case 'won':
        return 'Won';
      case 'lost':
        return 'Lost';
      case 'closed':
        return 'Closed';
      default:
        return status;
    }
  }

  bool get isExpired {
    if (createdAt.isEmpty) return false;
    final t = DateTime.tryParse(createdAt);
    if (t == null) return false;
    return DateTime.now().difference(t) > const Duration(hours: 24);
  }

  String get timeLeftLabel {
    if (createdAt.isEmpty) return '—';
    final t = DateTime.tryParse(createdAt);
    if (t == null) return '—';
    final left = t.add(const Duration(hours: 24)).difference(DateTime.now());
    if (left.isNegative) return 'Expired';
    final h = left.inHours;
    final m = left.inMinutes % 60;
    if (h > 0) return '${h}h ${m}m left';
    return '${m}m left';
  }
}

class SeekerBidsController extends GetxController {
  final _box = GetStorage();

  final mainSection = 0.obs; // 0 Offered · 1 My bids
  final selectedTab = 0.obs; // Received · Pending · Closed
  final selectedNavIndex = 1.obs;
  final coins = 500.obs;

  final myCreatedBids = <MyBidItem>[].obs;
  final myBidsSearch = ''.obs;

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
      offeredPrice: 'Rs 16,500/mo',
      yourBid: 'Rs 15,000/mo',
      phone: '+923001234567',
      roomType: 'Shared',
      seater: '2-seater',
    ),
    BidItem(
      id: 'r2',
      hostelName: 'Campus View Lodge',
      initials: 'CV',
      location: 'I-8, Islamabad',
      offeredPrice: 'Rs 15,200/mo',
      yourBid: 'Rs 15,500/mo',
      phone: '+923009876543',
      roomType: 'Private',
      seater: '1-seater',
    ),
  ].obs;

  final pending = <BidItem>[].obs;
  final closed = <BidItem>[].obs;

  @override
  void onInit() {
    super.onInit();
    loadMyBids();
  }

  @override
  void onReady() {
    super.onReady();
    loadMyBids();
  }

  void onMainSectionChanged(int i) {
    mainSection.value = i;
    if (i == 1) loadMyBids();
  }

  void onTabChanged(int i) => selectedTab.value = i;

  /// Load + drop bids older than 24h
  void loadMyBids() {
    final raw = (_box.read('seeker_my_bids') as List?) ?? [];
    final items = raw
        .map((e) => MyBidItem.fromMap(Map<String, dynamic>.from(e as Map)))
        .toList();

    final active = items.where((b) => !b.isExpired).toList();
    if (active.length != items.length) {
      _box.write('seeker_my_bids', active.map((e) => e.toMap()).toList());
      if (items.length > active.length) {
        AppSnackbar.info(
          'Expired',
          '${items.length - active.length} bid(s) removed after 24 hours',
        );
      }
    }
    myCreatedBids.assignAll(active);
  }

  List<MyBidItem> get filteredMyBids {
    final q = myBidsSearch.value.trim().toLowerCase();
    if (q.isEmpty) return myCreatedBids.toList();
    return myCreatedBids.where((b) {
      return b.seater.toLowerCase().contains(q) ||
          b.yourOffer.toLowerCase().contains(q) ||
          b.hostelType.toLowerCase().contains(q) ||
          b.status.toLowerCase().contains(q) ||
          b.amenities.any((a) => a.toLowerCase().contains(q));
    }).toList();
  }

  void onMyBidsSearchChanged(String v) => myBidsSearch.value = v;

  void openMyBidDetail(MyBidItem item) {
    Get.toNamed(AppRoutes.seekerMyBidDetail, arguments: item);
  }

  void updateBid(
    String id, {
    required String seater,
    required String offer,
    required List<String> amenities,
    required String hostelType,
    required int offerAmount,
  }) {
    final index = myCreatedBids.indexWhere((b) => b.id == id);
    if (index == -1) return;
    final old = myCreatedBids[index];
    myCreatedBids[index] = MyBidItem(
      id: old.id,
      seater: seater,
      amenities: amenities,
      yourOffer: offer,
      status: old.status,
      createdAt: old.createdAt,
      location: old.location,
      hostelType: hostelType,
      offerAmount: offerAmount,
      endsIn: old.endsIn,
    );
    myCreatedBids.refresh();
    _saveMyBids();
    AppSnackbar.success('Updated', 'Bid saved successfully.');
  }

  void deleteBid(MyBidItem item) {
    myCreatedBids.removeWhere((b) => b.id == item.id);
    _saveMyBids();
    AppSnackbar.info('Removed', 'Bid deleted.');
  }

  void _saveMyBids() {
    _box.write(
      'seeker_my_bids',
      myCreatedBids.map((e) => e.toMap()).toList(),
    );
  }

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.seekerHome);
        break;
      case 1:
        break;
      case 2:
        Get.offAllNamed(AppRoutes.seekerSearch);
        break;
      case 3:
        Get.toNamed(AppRoutes.profile);
        selectedNavIndex.value = 1;
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
    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 24, 22, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.accent.withValues(alpha: 0.12),
                ),
                child: const Icon(Icons.home_work_rounded,
                    color: AppColors.accent, size: 28),
              ),
              const SizedBox(height: 14),
              const Text(
                'Confirm acceptance',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'By accepting, you confirm that you have visited '
                '${item.hostelName} and everything matches what the manager offered '
                '(${item.offeredPrice}, ${item.roomType}, ${item.seater}).\n\n'
                'Do you want to continue?',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  color: AppColors.textSecondary,
                  fontSize: 13.5,
                  height: 1.45,
                ),
              ),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        Get.back();
                        pending.removeWhere((e) => e.id == item.id);
                        closed.add(item);
                        selectedTab.value = 2;
                        AppSnackbar.success(
                          'Accepted',
                          'Deal closed with ${item.hostelName}.',
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                      ),
                      child: const Text('Yes, continue',
                          style: TextStyle(fontWeight: FontWeight.w700)),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onReject(BidItem item) {
    final reasonCtrl = TextEditingController();
    final selectedReason = ''.obs;
    const reasons = [
      'Price too high',
      'Location not suitable',
      'Facilities not as offered',
      'Found a better option',
      'Other',
    ];

    Get.dialog(
      barrierDismissible: false,
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 24),
        child: Container(
          padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: AppColors.border),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Text(
                  'Reject offer?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Why are you rejecting ${item.hostelName}?',
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 13.5,
                  ),
                ),
                const SizedBox(height: 16),
                Obx(
                  () => Column(
                    children: reasons.map((r) {
                      final sel = selectedReason.value == r;
                      return Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: GestureDetector(
                          onTap: () => selectedReason.value = r,
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 12,
                            ),
                            decoration: BoxDecoration(
                              color: sel
                                  ? AppColors.error.withValues(alpha: 0.08)
                                  : AppColors.surfaceSoft,
                              borderRadius: BorderRadius.circular(14),
                              border: Border.all(
                                color:
                                    sel ? AppColors.error : AppColors.border,
                              ),
                            ),
                            child: Text(
                              r,
                              style: TextStyle(
                                color: sel
                                    ? AppColors.error
                                    : AppColors.textPrimary,
                                fontWeight:
                                    sel ? FontWeight.w700 : FontWeight.w500,
                                fontSize: 13.5,
                              ),
                            ),
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                Obx(() {
                  if (selectedReason.value != 'Other') {
                    return const SizedBox.shrink();
                  }
                  return TextField(
                    controller: reasonCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'Write your reason…',
                      filled: true,
                      fillColor: AppColors.surfaceSoft,
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                  );
                }),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Expanded(
                      child: OutlinedButton(
                        onPressed: () => Get.back(),
                        child: const Text('Cancel'),
                      ),
                    ),
                    const SizedBox(width: 10),
                    Expanded(
                      child: ElevatedButton(
                        onPressed: () {
                          if (selectedReason.value.isEmpty) {
                            AppSnackbar.warning(
                                'Reason', 'Please select a reason');
                            return;
                          }
                          if (selectedReason.value == 'Other' &&
                              reasonCtrl.text.trim().isEmpty) {
                            AppSnackbar.warning(
                                'Reason', 'Please write your reason');
                            return;
                          }
                          final reason = selectedReason.value == 'Other'
                              ? reasonCtrl.text.trim()
                              : selectedReason.value;
                          Get.back();
                          pending.removeWhere((e) => e.id == item.id);
                          AppSnackbar.info('Rejected', 'Reason: $reason');
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.error,
                          foregroundColor: Colors.white,
                        ),
                        child: const Text('Reject'),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void onCall(String phone) => AppSnackbar.info('Calling', phone);

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
    final index = closed.indexWhere((e) => e.id == item.id);
    if (index != -1) {
      closed[index].overallRating = overallRating;
      closed.refresh();
    }
    Get.back();
    AppSnackbar.success(
      'Review submitted',
      'Thanks! Overall ${overallRating.toStringAsFixed(1)}',
    );
  }

  void resetReview() {
    reviewRatings.updateAll((key, value) => 0);
    reviewRatings.refresh();
    reviewText.value = '';
  }
}