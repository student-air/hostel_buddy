import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../core/utils/app_snackbar.dart';
import '../../../routes/app_routes.dart';

class SeekerMapController extends GetxController {
  final selectedFilter = 'All'.obs;
  final searchQuery = ''.obs;

  final filters = ['All', 'Nearby', 'Under 10k', 'Shared', 'Private'];

  GoogleMapController? mapController;

  // Islamabad center
  static const LatLng initialTarget = LatLng(33.6844, 73.0479);

  final hostels = <Map<String, dynamic>>[
    {
      'name': 'Green Valley Hostel',
      'area': 'G-9',
      'city': 'Islamabad',
      'distance': '1.2 km',
      'price': 'Rs 12k/mo',
      'rating': 4.6,
      'lat': 33.6938,
      'lng': 73.0652,
    },
    {
      'name': 'Campus View Lodge',
      'area': 'I-8',
      'city': 'Islamabad',
      'distance': '2.4 km',
      'price': 'Rs 9.5k/mo',
      'rating': 4.3,
      'lat': 33.6684,
      'lng': 73.0745,
    },
    {
      'name': 'Scholar Nest',
      'area': 'F-7',
      'city': 'Islamabad',
      'distance': '3.1 km',
      'price': 'Rs 14k/mo',
      'rating': 4.8,
      'lat': 33.7215,
      'lng': 73.0570,
    },
    {
      'name': 'Al-Haram Hostel',
      'area': 'G-11',
      'city': 'Islamabad',
      'distance': '1.8 km',
      'price': 'Rs 11k/mo',
      'rating': 4.4,
      'lat': 33.6690,
      'lng': 72.9980,
    },
  ].obs;

  final selectedHostel = Rxn<Map<String, dynamic>>();
  final markers = <Marker>{}.obs;

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
    return list;
  }

  @override
  void onInit() {
    super.onInit();
    _buildMarkers();
  }

  void _buildMarkers() {
    markers.clear();
    for (final h in filtered) {
      final lat = (h['lat'] as num).toDouble();
      final lng = (h['lng'] as num).toDouble();
      final id = h['name'].toString();
      markers.add(
        Marker(
          markerId: MarkerId(id),
          position: LatLng(lat, lng),
          infoWindow: InfoWindow(
            title: h['name']?.toString(),
            snippet: '${h['price']} · ${h['distance']}',
          ),
          onTap: () => selectHostel(h),
          icon: BitmapDescriptor.defaultMarkerWithHue(
            selectedHostel.value == h
                ? BitmapDescriptor.hueAzure
                : BitmapDescriptor.hueRose,
          ),
        ),
      );
    }
    markers.refresh();
  }

  void onMapCreated(GoogleMapController c) {
    mapController = c;
  }

  void selectHostel(Map<String, dynamic> h) {
    selectedHostel.value = h;
    _buildMarkers();
    final lat = (h['lat'] as num).toDouble();
    final lng = (h['lng'] as num).toDouble();
    mapController?.animateCamera(
      CameraUpdate.newLatLngZoom(LatLng(lat, lng), 14.5),
    );
  }

  void onHostelTap(Map<String, dynamic> h) {
    selectHostel(h);
    AppSnackbar.info(h['name']?.toString() ?? 'Hostel', 'Details coming next.');
  }

  void onFilterChanged(String f) {
    selectedFilter.value = f;
    _buildMarkers();
  }

  void onSearchChanged(String q) {
    searchQuery.value = q;
    _buildMarkers();
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