import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class MyBidItem {
  MyBidItem({
    required this.id,
    required this.seater,
    required this.amenities,
    required this.yourOffer,
    required this.status,
    required this.createdAt,
    this.location = '',
    this.endsIn = '6h',
  });

  final String id;
  final String seater;
  final List<String> amenities;
  final String yourOffer;
  final String status;
  final String createdAt;
  final String location;
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
      endsIn: map['endsIn']?.toString() ?? '6h',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'seater': seater,
      'amenities': amenities,
      'yourOffer': yourOffer,
      'status': status,
      'createdAt': createdAt,
      'location': location,
      'endsIn': endsIn,
    };
  }

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
}

class SeekerMyBidsController extends GetxController {
  final _box = GetStorage();
  final allBids = <MyBidItem>[].obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    loadBids();
  }

  @override
  void onReady() {
    super.onReady();
    loadBids();
  }

  void loadBids() {
    final raw = (_box.read('seeker_my_bids') as List?) ?? [];
    allBids.assignAll(
      raw.map((e) => MyBidItem.fromMap(Map<String, dynamic>.from(e as Map))),
    );
  }

  List<MyBidItem> get filteredBids {
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isEmpty) return allBids.toList();
    return allBids.where((b) {
      return b.seater.toLowerCase().contains(q) ||
          b.yourOffer.toLowerCase().contains(q) ||
          b.status.toLowerCase().contains(q) ||
          b.amenities.any((a) => a.toLowerCase().contains(q));
    }).toList();
  }

  void onSearchChanged(String value) => searchQuery.value = value;

  void openDetail(MyBidItem item) {
    Get.toNamed(AppRoutes.seekerMyBidDetail, arguments: item);
  }

  void updateBid(
    String id, {
    required String seater,
    required String offer,
    required List<String> amenities,
  }) {
    final index = allBids.indexWhere((b) => b.id == id);
    if (index == -1) return;

    final old = allBids[index];
    allBids[index] = MyBidItem(
      id: old.id,
      seater: seater,
      amenities: amenities,
      yourOffer: offer,
      status: old.status,
      createdAt: old.createdAt,
      location: old.location,
      endsIn: old.endsIn,
    );
    allBids.refresh();
    _save();
    AppSnackbar.success('Updated', 'Bid saved successfully.');
  }

  void deleteBid(MyBidItem item) {
    allBids.removeWhere((b) => b.id == item.id);
    allBids.refresh();
    _save();
    AppSnackbar.info('Removed', 'Bid deleted.');
  }

  void _save() {
    _box.write('seeker_my_bids', allBids.map((e) => e.toMap()).toList());
  }
}