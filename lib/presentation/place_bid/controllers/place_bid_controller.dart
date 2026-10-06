import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class PlaceBidController extends GetxController {
  static const int minBid = 15000;

  final selectedHostelType = 'Boys Hostel'.obs;
  final selectedSeater = '3 Seater'.obs;
  final selectedAmenities = <String>{'Wifi', 'AC', 'Laundry'}.obs;
  final yourOffer = minBid.obs;

  final seaters = <String>[
    '1 Seater',
    '2 Seater',
    '3 Seater',
    '4 Seater',
    '5+ Seater',
  ].obs;

  final amenities = [
    'Wifi',
    'AC',
    'Heater',
    'Ironing',
    'Laundry',
    'Geyser',
    'Parking',
    'CCTV',
    'Mess',
    'Generator',
    'Lift',
    'Furnished',
  ];

  final customSeaterController = TextEditingController();

  bool get canDecrease => yourOffer.value > minBid;
  bool get canPlaceBid => yourOffer.value >= minBid;
  bool get allAmenitiesSelected =>
      selectedAmenities.length == amenities.length;

  void selectHostelType(String value) => selectedHostelType.value = value;

  void selectSeater(String value) => selectedSeater.value = value;

  void toggleAmenity(String value) {
    if (selectedAmenities.contains(value)) {
      selectedAmenities.remove(value);
    } else {
      selectedAmenities.add(value);
    }
    selectedAmenities.refresh();
  }

  void toggleSelectAllAmenities() {
    if (allAmenitiesSelected) {
      selectedAmenities.clear();
    } else {
      selectedAmenities
        ..clear()
        ..addAll(amenities);
    }
    selectedAmenities.refresh();
  }

  void decreaseOffer() {
    if (yourOffer.value > minBid) {
      yourOffer.value = (yourOffer.value - 500).clamp(minBid, 999999999);
    }
  }

  void increaseOffer() => yourOffer.value += 500;

  void addAmount(int amount) => yourOffer.value += amount;

  void placeBid() {
    if (yourOffer.value < minBid) {
      AppSnackbar.warning(
        'Minimum bid',
        'Offer must be at least Rs ${formatAmount(minBid)}',
      );
      return;
    }

    final box = GetStorage();
    final bid = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'hostelType': selectedHostelType.value,
      'seater': selectedSeater.value,
      'amenities': selectedAmenities.toList(),
      'yourOffer': 'Rs ${formatAmount(yourOffer.value)}/mo',
      'offerAmount': yourOffer.value,
      'status': 'pending',
      'createdAt': DateTime.now().toIso8601String(),
      'location': '',
    };

    final existing = List<Map>.from(
      (box.read('seeker_my_bids') as List?)?.map((e) => Map<String, dynamic>.from(e as Map)) ??
          [],
    );
    existing.insert(0, bid);
    box.write('seeker_my_bids', existing);

    AppSnackbar.success(
      'Bid placed',
      'Your offer Rs ${formatAmount(yourOffer.value)} is live.',
    );

    Get.offNamed(AppRoutes.seekerBids);
  }

  String formatAmount(int amount) {
    final s = amount.toString();
    final buf = StringBuffer();
    for (int i = 0; i < s.length; i++) {
      final fromEnd = s.length - i;
      buf.write(s[i]);
      if (fromEnd > 1 && fromEnd % 3 == 1) buf.write(',');
    }
    return buf.toString();
  }

  void openAddSeaterDialog() {
    customSeaterController.clear();
    Get.dialog(
      Dialog(
        backgroundColor: Colors.transparent,
        insetPadding: const EdgeInsets.symmetric(horizontal: 28),
        child: Container(
          padding: const EdgeInsets.fromLTRB(22, 22, 22, 18),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: AppColors.border),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add custom seater',
                style: TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customSeaterController,
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
                cursorColor: AppColors.primary,
                decoration: InputDecoration(
                  hintText: 'e.g. 6 Seater, Studio',
                  hintStyle: const TextStyle(color: AppColors.textMuted),
                  filled: true,
                  fillColor: AppColors.surfaceSoft,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.border),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.primary),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton(
                      onPressed: () => Get.back(),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.textPrimary,
                        side: const BorderSide(color: AppColors.border),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(24),
                        ),
                        minimumSize: const Size(0, 46),
                      ),
                      child: const Text('Cancel',
                          style: TextStyle(fontWeight: FontWeight.w600)),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: () {
                        final text = customSeaterController.text.trim();
                        if (text.isEmpty) {
                          AppSnackbar.warning('Empty', 'Enter a seater type');
                          return;
                        }
                        if (!seaters.contains(text)) seaters.add(text);
                        selectedSeater.value = text;
                        Get.back();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.accent,
                        foregroundColor: Colors.white,
                        elevation: 0,
                        minimumSize: const Size(0, 46),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                      child: const Text('Add',
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

  @override
  void onClose() {
    customSeaterController.dispose();
    super.onClose();
  }
}