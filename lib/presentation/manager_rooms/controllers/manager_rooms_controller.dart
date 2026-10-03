import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class HostelRoom {
  HostelRoom({
    required this.id,
    required this.number,
    required this.seater,
    required this.rent,
    required this.status, // vacant | occupied | reserved
    this.floor = '1',
  });

  final String id;
  String number;
  String seater;
  String rent;
  String status;
  String floor;
}

class ManagerRoomsController extends GetxController {
  final _box = GetStorage();

  final selectedNavIndex = 2.obs; // Rooms tab
  final selectedFilter = 0.obs; // 0 All · 1 Vacant · 2 Occupied · 3 Reserved
  final searchQuery = ''.obs;

  final rooms = <HostelRoom>[
    HostelRoom(
      id: '1',
      number: '101',
      seater: '2-seater',
      rent: 'Rs 12,000/mo',
      status: 'occupied',
      floor: '1',
    ),
    HostelRoom(
      id: '2',
      number: '102',
      seater: '3-seater',
      rent: 'Rs 10,000/mo',
      status: 'vacant',
      floor: '1',
    ),
    HostelRoom(
      id: '3',
      number: '201',
      seater: '4-seater',
      rent: 'Rs 9,000/mo',
      status: 'reserved',
      floor: '2',
    ),
    HostelRoom(
      id: '4',
      number: '202',
      seater: '2-seater',
      rent: 'Rs 12,500/mo',
      status: 'occupied',
      floor: '2',
    ),
    HostelRoom(
      id: '5',
      number: '301',
      seater: 'Single',
      rent: 'Rs 15,000/mo',
      status: 'vacant',
      floor: '3',
    ),
  ].obs;

  int get totalCount => rooms.length;
  int get vacantCount => rooms.where((r) => r.status == 'vacant').length;
  int get occupiedCount => rooms.where((r) => r.status == 'occupied').length;
  int get reservedCount => rooms.where((r) => r.status == 'reserved').length;

  List<HostelRoom> get filtered {
    var list = rooms.toList();
    switch (selectedFilter.value) {
      case 1:
        list = list.where((r) => r.status == 'vacant').toList();
        break;
      case 2:
        list = list.where((r) => r.status == 'occupied').toList();
        break;
      case 3:
        list = list.where((r) => r.status == 'reserved').toList();
        break;
    }
    final q = searchQuery.value.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (r) =>
                r.number.toLowerCase().contains(q) ||
                r.seater.toLowerCase().contains(q) ||
                r.floor.toLowerCase().contains(q),
          )
          .toList();
    }
    return list;
  }

  void onFilterChanged(int i) => selectedFilter.value = i;
  void onSearchChanged(String q) => searchQuery.value = q;

  void onNavTap(int index) {
    if (index == selectedNavIndex.value) return;
    selectedNavIndex.value = index;
    switch (index) {
      case 0:
        Get.offAllNamed(AppRoutes.managerHome);
        break;
      case 1:
        Get.offAllNamed(AppRoutes.managerIncomingBids);
        break;
      case 2:
        break;
      case 3:
        Get.toNamed(AppRoutes.profile);
        selectedNavIndex.value = 2;
        break;
    }
  }

  void onAddRoom() {
    final numberCtrl = TextEditingController();
    final seaterCtrl = TextEditingController(text: '2-seater');
    final rentCtrl = TextEditingController();
    final floorCtrl = TextEditingController(text: '1');
    final status = 'vacant'.obs;

    Get.bottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.black.withValues(alpha: 0.35),
      Container(
        padding: EdgeInsets.fromLTRB(
          20,
          12,
          20,
          20 + MediaQuery.of(Get.context!).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        ),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  margin: const EdgeInsets.only(bottom: 16),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEEE0E6),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const Text(
                'Add room',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: Color(0xFF57092D),
                ),
              ),
              const SizedBox(height: 16),
              _field(numberCtrl, 'Room number', 'e.g. 105'),
              const SizedBox(height: 12),
              _field(seaterCtrl, 'Seater type', 'e.g. 2-seater'),
              const SizedBox(height: 12),
              _field(rentCtrl, 'Monthly rent', 'e.g. 12000',
                  keyboard: TextInputType.number),
              const SizedBox(height: 12),
              _field(floorCtrl, 'Floor', 'e.g. 1'),
              const SizedBox(height: 12),
              Obx(
                () => Wrap(
                  spacing: 8,
                  children: ['vacant', 'occupied', 'reserved'].map((s) {
                    final sel = status.value == s;
                    return ChoiceChip(
                      label: Text(
                        s[0].toUpperCase() + s.substring(1),
                        style: TextStyle(
                          color: sel ? Colors.white : const Color(0xFF57092D),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      selected: sel,
                      selectedColor: const Color(0xFF0D9488),
                      backgroundColor: const Color(0xFFFCF5FD),
                      onSelected: (_) => status.value = s,
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),
              SizedBox(
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    final num = numberCtrl.text.trim();
                    if (num.isEmpty) {
                      AppSnackbar.warning('Room', 'Enter room number');
                      return;
                    }
                    final rentRaw = rentCtrl.text.trim();
                    final rentLabel = rentRaw.isEmpty
                        ? 'Rs —'
                        : 'Rs ${_format(rentRaw)}/mo';
                    rooms.add(
                      HostelRoom(
                        id: DateTime.now().millisecondsSinceEpoch.toString(),
                        number: num,
                        seater: seaterCtrl.text.trim().isEmpty
                            ? '2-seater'
                            : seaterCtrl.text.trim(),
                        rent: rentLabel,
                        status: status.value,
                        floor: floorCtrl.text.trim().isEmpty
                            ? '1'
                            : floorCtrl.text.trim(),
                      ),
                    );
                    Get.back();
                    AppSnackbar.success('Added', 'Room $num added');
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0D9488),
                    foregroundColor: Colors.white,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(24),
                    ),
                  ),
                  child: const Text(
                    'Add room',
                    style: TextStyle(fontWeight: FontWeight.w700),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void onRoomTap(HostelRoom room) {
    // Toggle vacant <-> occupied for demo
    if (room.status == 'vacant') {
      room.status = 'occupied';
    } else if (room.status == 'occupied') {
      room.status = 'vacant';
    } else {
      room.status = 'vacant';
    }
    rooms.refresh();
    AppSnackbar.info('Updated', 'Room ${room.number} → ${room.status}');
  }

  void onDeleteRoom(HostelRoom room) {
    rooms.removeWhere((r) => r.id == room.id);
    AppSnackbar.info('Removed', 'Room ${room.number} deleted');
  }

  Widget _field(
    TextEditingController c,
    String label,
    String hint, {
    TextInputType keyboard = TextInputType.text,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: Color(0xFFA97887),
          ),
        ),
        const SizedBox(height: 6),
        TextField(
          controller: c,
          keyboardType: keyboard,
          style: const TextStyle(
            color: Color(0xFF57092D),
            fontWeight: FontWeight.w600,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Color(0xFFC6A0B2)),
            filled: true,
            fillColor: const Color(0xFFFFF5F8),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEEE0E6)),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(color: Color(0xFFEEE0E6)),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(14),
              borderSide: const BorderSide(
                color: Color(0xFF95314D),
                width: 1.4,
              ),
            ),
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          ),
        ),
      ],
    );
  }

  String _format(String raw) {
    final n = int.tryParse(raw.replaceAll(',', '')) ?? 0;
    final s = n.toString();
    final buf = StringBuffer();
    for (var i = 0; i < s.length; i++) {
      if (i > 0 && (s.length - i) % 3 == 0) buf.write(',');
      buf.write(s[i]);
    }
    return buf.toString();
  }
}