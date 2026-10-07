import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
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
    required this.status, // pending | offered | accepted
    this.managerOffer,
  });

  final String id;
  final String seekerName;
  final String seater;
  /// Original seeker offer, e.g. "Rs 11,000/mo"
  final String offer;
  final List<String> amenities;
  final String time;
  String status;
  /// Final offer manager sent (same or higher). Null while still pending.
  String? managerOffer;

  String get initials {
    final parts = seekerName.trim().split(RegExp(r'\s+'));
    if (parts.isEmpty || parts.first.isEmpty) return '?';
    if (parts.length == 1) return parts.first[0].toUpperCase();
    return '${parts.first[0]}${parts.last[0]}'.toUpperCase();
  }

  /// Numeric part of seeker offer for the dialog field
  int get offerAmount {
    final digits = RegExp(r'[\d,]+').firstMatch(offer)?.group(0) ?? '0';
    return int.tryParse(digits.replaceAll(',', '')) ?? 0;
  }
}

class ManagerIncomingBidsController extends GetxController {
  /// 0 All · 1 Offered · 2 Accepted
  final selectedTab = 0.obs;
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
      status: 'offered',
      managerOffer: 'Rs 10,500/mo',
    ),
    IncomingBid(
      id: '4',
      seekerName: 'Fatima Noor',
      seater: '2 Seater',
      offer: 'Rs 10,500/mo',
      amenities: ['Wifi', 'AC', 'Parking'],
      time: '2d ago',
      status: 'accepted',
      managerOffer: 'Rs 10,500/mo',
    ),
    IncomingBid(
  id: '5',
  seekerName: 'Usman Malik',
  seater: '4 Seater',
  offer: 'Rs 8,500/mo',
  amenities: ['Wifi', 'Mess', 'Laundry'],
  time: '3h ago',
  status: 'pending',
),
IncomingBid(
  id: '6',
  seekerName: 'Ayesha Siddiqui',
  seater: '2 Seater',
  offer: 'Rs 12,000/mo',
  amenities: ['Wifi', 'AC', 'Security'],
  time: '6h ago',
  status: 'pending',
),
  ].obs;

  List<IncomingBid> get filtered {
  var list = bids.toList();
  switch (selectedTab.value) {
    case 0: // All → only pending (accept / reject)
      list = list.where((b) => b.status == 'pending').toList();
      break;
    case 1: // Offered
      list = list.where((b) => b.status == 'offered').toList();
      break;
    case 2: // Accepted
      list = list.where((b) => b.status == 'accepted').toList();
      break;
  }
  final q = searchQuery.value.trim().toLowerCase();
  if (q.isNotEmpty) {
    list = list
        .where(
          (b) =>
              b.seekerName.toLowerCase().contains(q) ||
              b.seater.toLowerCase().contains(q) ||
              b.offer.toLowerCase().contains(q) ||
              (b.managerOffer?.toLowerCase().contains(q) ?? false),
        )
        .toList();
  }
  return list;
}

  void onTabChanged(int i) => selectedTab.value = i;
  void onSearchChanged(String q) => searchQuery.value = q;

  /// Reject → remove bid completely (no rejected data)
  void rejectBid(IncomingBid bid) {
    bids.removeWhere((b) => b.id == bid.id);
    AppSnackbar.info('Rejected', 'Bid from ${bid.seekerName} removed');
  }

  /// Accept button → open confirmation dialog (same price or increase)
    /// Accept button → glassy confirmation dialog (same style as logout)
    void onAcceptTap(IncomingBid bid) {
  final priceCtrl = TextEditingController(text: '${bid.offerAmount}');
  final samePrice = true.obs;

  Get.dialog(
    barrierDismissible: false,
    barrierColor: Colors.black.withValues(alpha: 0.35),
    Dialog(
      backgroundColor: Colors.transparent,
      insetPadding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
      child: Obx(
        () => ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(Get.context!).size.height * 0.78,
          ),
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
              border: Border.all(color: AppColors.border),
              boxShadow: [
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.1),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(20, 22, 20, 16),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppColors.success.withValues(alpha: 0.12),
                    ),
                    child: const Icon(
                      Icons.gavel_rounded,
                      size: 26,
                      color: AppColors.success,
                    ),
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Confirm offer',
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 19,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.3,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${bid.seekerName} · ${bid.seater}',
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Seeker offer: ${bid.offer}',
                    style: const TextStyle(
                      color: AppColors.accent,
                      fontSize: 13.5,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                  const SizedBox(height: 16),
                  _LightOption(
                    selected: samePrice.value,
                    title: 'Accept at same price',
                    subtitle: bid.offer,
                    onTap: () {
                      samePrice.value = true;
                      priceCtrl.text = '${bid.offerAmount}';
                    },
                  ),
                  const SizedBox(height: 8),
                  _LightOption(
                    selected: !samePrice.value,
                    title: 'Increase price',
                    subtitle: 'Set your counter offer',
                    onTap: () => samePrice.value = false,
                  ),
                  if (!samePrice.value) ...[
                    const SizedBox(height: 12),
                    TextField(
                      controller: priceCtrl,
                      keyboardType: TextInputType.number,
                      style: const TextStyle(
                        color: AppColors.textPrimary,
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                      ),
                      cursorColor: AppColors.primary,
                      decoration: InputDecoration(
                        prefixText: 'Rs ',
                        prefixStyle: const TextStyle(
                          color: AppColors.textPrimary,
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                        ),
                        suffixText: '/mo',
                        suffixStyle: const TextStyle(
                          color: AppColors.textSecondary,
                          fontSize: 13,
                        ),
                        hintText: 'Amount',
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
                          borderSide: const BorderSide(
                            color: AppColors.primary,
                            width: 1.5,
                          ),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ],
                  const SizedBox(height: 18),
                  Row(
                    children: [
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: OutlinedButton(
                            onPressed: () => Get.back(),
                            style: OutlinedButton.styleFrom(
                              foregroundColor: AppColors.textPrimary,
                              side: const BorderSide(color: AppColors.border),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Cancel',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: SizedBox(
                          height: 46,
                          child: ElevatedButton(
                            onPressed: () {
                              final raw =
                                  priceCtrl.text.replaceAll(',', '').trim();
                              final amount = int.tryParse(raw) ?? 0;
                              if (!samePrice.value &&
                                  amount < bid.offerAmount) {
                                AppSnackbar.error(
                                  'Invalid',
                                  'Price must be same or higher than seeker offer',
                                );
                                return;
                              }
                              final finalOffer = samePrice.value
                                  ? bid.offer
                                  : 'Rs ${_formatAmount(amount)}/mo';
                              Get.back();
                              _confirmOffer(bid, finalOffer);
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.success,
                              foregroundColor: Colors.white,
                              elevation: 0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24),
                              ),
                            ),
                            child: const Text(
                              'Confirm',
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w700,
                              ),
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
        ),
      ),
    ),
  );
}
  
  void _confirmOffer(IncomingBid bid, String finalOffer) {
    bid.status = 'offered';
    bid.managerOffer = finalOffer;
    bids.refresh();
    AppSnackbar.success(
      'Offer sent',
      'Your offer ($finalOffer) sent to ${bid.seekerName}',
    );
  }

  String _formatAmount(int n) {
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }

  void onNavTap(int index) {
  if (index == selectedNavIndex.value) return;

  selectedNavIndex.value = index;
  switch (index) {
    case 0:
      Get.offAllNamed(AppRoutes.managerHome);
      break;
    case 1:
      // Already on bids
      break;
    case 2:
  Get.offAllNamed(AppRoutes.managerRooms);
  break;
    case 3:
      Get.toNamed(AppRoutes.profile);
      selectedNavIndex.value = 1;
      break;
  }
}
void deleteOfferedBid(IncomingBid bid) {
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
                color: AppColors.error.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.error,
                size: 28,
              ),
            ),
            const SizedBox(height: 16),
            const Text(
              'Delete this offer?',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Remove the offer for ${bid.seekerName}? This cannot be undone.',
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 14,
                height: 1.4,
              ),
            ),
            const SizedBox(height: 22),
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
                    child: const Text(
                      'Cancel',
                      style: TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () {
                      Get.back();
                      bids.removeWhere((b) => b.id == bid.id);
                      AppSnackbar.info('Deleted', 'Offer removed.');
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.error,
                      foregroundColor: Colors.white,
                      elevation: 0,
                      minimumSize: const Size(0, 46),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(24),
                      ),
                    ),
                    child: const Text(
                      'Delete',
                      style: TextStyle(fontWeight: FontWeight.w700),
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
}

/// Glass radio option inside the confirm dialog
class _LightOption extends StatelessWidget {
  const _LightOption({
    required this.selected,
    required this.title,
    required this.subtitle,
    required this.onTap,
  });

  final bool selected;
  final String title;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: selected
              ? AppColors.accent.withValues(alpha: 0.1)
              : AppColors.surfaceSoft,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: selected ? AppColors.accent : AppColors.border,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: [
            Container(
              width: 22,
              height: 22,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: selected ? AppColors.accent : AppColors.textMuted,
                  width: 2,
                ),
              ),
              child: selected
                  ? Center(
                      child: Container(
                        width: 12,
                        height: 12,
                        decoration: const BoxDecoration(
                          shape: BoxShape.circle,
                          color: AppColors.accent,
                        ),
                      ),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      color: AppColors.textPrimary,
                      fontSize: 14,
                      fontWeight:
                          selected ? FontWeight.w700 : FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
