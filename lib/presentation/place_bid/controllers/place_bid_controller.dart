import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/utils/app_snackbar.dart';

class PlaceBidController extends GetxController {
  final selectedSeater = '3 Seater'.obs;
  final selectedAmenities = <String>{'Wifi', 'AC', 'Laundry'}.obs;

  final currentHighestBid = 12000.obs;
  final bidsSoFar = 8.obs;
  final yourOffer = 13000.obs;

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

  bool get isHighest => yourOffer.value > currentHighestBid.value;

  void selectSeater(String value) => selectedSeater.value = value;

  void toggleAmenity(String value) {
    if (selectedAmenities.contains(value)) {
      selectedAmenities.remove(value);
    } else {
      selectedAmenities.add(value);
    }
    selectedAmenities.refresh();
  }

  void decreaseOffer() {
    if (yourOffer.value > 500) yourOffer.value -= 500;
  }

  void increaseOffer() => yourOffer.value += 500;

  void addAmount(int amount) => yourOffer.value += amount;

  void placeBid() {
    if (!isHighest) {
      AppSnackbar.warning(
        'Bid too low',
        'Bid must be higher than Rs ${formatAmount(currentHighestBid.value)}',
      );
      return;
    }
    AppSnackbar.success(
      'Bid placed',
      'Your offer Rs ${formatAmount(yourOffer.value)} is live.',
    );
    Get.back();
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
            color: const Color(0xFF2A0412),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(color: Colors.white.withValues(alpha: 0.12)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Add custom seater',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                'e.g. 6 Seater, Studio, etc.',
                style: TextStyle(
                  color: Colors.white.withValues(alpha: 0.5),
                  fontSize: 13,
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: customSeaterController,
                style: const TextStyle(color: Colors.white, fontSize: 15),
                cursorColor: AppColors.accentLight,
                decoration: InputDecoration(
                  hintText: 'Enter seater type',
                  hintStyle: TextStyle(
                    color: Colors.white.withValues(alpha: 0.35),
                  ),
                  filled: true,
                  fillColor: Colors.white.withValues(alpha: 0.06),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: BorderSide(
                      color: Colors.white.withValues(alpha: 0.12),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                    borderSide: const BorderSide(color: AppColors.accent),
                  ),
                ),
              ),
              const SizedBox(height: 18),
              Row(
                children: [
                  Expanded(
                    child: SizedBox(
                      height: 46,
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
                          style: TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: SizedBox(
                      height: 46,
                      child: ElevatedButton(
                        onPressed: () {
                          final text = customSeaterController.text.trim();
                          if (text.isEmpty) {
                            AppSnackbar.warning('Empty', 'Enter a seater type');
                            return;
                          }
                          if (!seaters.contains(text)) {
                            seaters.add(text);
                          }
                          selectedSeater.value = text;
                          Get.back();
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.accent,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                          'Add',
                          style: TextStyle(fontWeight: FontWeight.w700),
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
    );
  }

  @override
  void onClose() {
    customSeaterController.dispose();
    super.onClose();
  }
}