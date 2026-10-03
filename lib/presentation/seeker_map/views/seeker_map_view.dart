import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../controllers/seeker_map_controller.dart';

class SeekerMapView extends GetView<SeekerMapController> {
  const SeekerMapView({super.key});

  @override
  Widget build(BuildContext context) {
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark,
      child: Scaffold(
        backgroundColor: AppColors.scaffoldBackground,
        body: Stack(
          children: [
            // Sample map canvas
            Container(
              width: double.infinity,
              height: double.infinity,
              color: const Color(0xFFF0E8EC),
            ),
            CustomPaint(
              size: Size.infinite,
              painter: _SampleMapPainter(),
            ),
            ..._samplePins(context),

            // Top UI
           Column(
      children: [
        _Header(), // full-width curved maroon
        const SizedBox(height: 12),
        _SearchBar(controller: controller),
        const SizedBox(height: 10),
        _Filters(controller: controller),
      ],
    ),

            // Bottom list
            Align(
              alignment: Alignment.bottomCenter,
              child: _BottomSheet(controller: controller),
            ),
          ],
        ),
      ),
    );
  }

  List<Widget> _samplePins(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final positions = [
      Offset(size.width * 0.28, size.height * 0.32),
      Offset(size.width * 0.62, size.height * 0.28),
      Offset(size.width * 0.45, size.height * 0.40),
      Offset(size.width * 0.72, size.height * 0.38),
    ];
    return List.generate(positions.length, (i) {
      final pinColor = i == 0 ? AppColors.accent : AppColors.primary;
      return Positioned(
        left: positions[i].dx - 18,
        top: positions[i].dy - 36,
        child: Column(
          children: [
            Container(
              width: 36,
              height: 36,
              decoration: BoxDecoration(
                color: pinColor,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 2),
                boxShadow: [
                  BoxShadow(
                    color: pinColor.withValues(alpha: 0.35),
                    blurRadius: 8,
                    offset: const Offset(0, 3),
                  ),
                ],
              ),
              child: const Icon(
                Icons.home_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
            Container(width: 2, height: 10, color: pinColor),
          ],
        ),
      );
    });
  }
}

class _SampleMapPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final road = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.08)
      ..strokeWidth = 2;
    final roadBold = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.12)
      ..strokeWidth = 4;

    for (var y = 80.0; y < size.height; y += 90) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), road);
    }
    for (var x = 40.0; x < size.width; x += 70) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), road);
    }
    canvas.drawLine(
      Offset(0, size.height * 0.35),
      Offset(size.width, size.height * 0.35),
      roadBold,
    );
    canvas.drawLine(
      Offset(size.width * 0.4, 0),
      Offset(size.width * 0.4, size.height),
      roadBold,
    );

    final block = Paint()..color = AppColors.primary.withValues(alpha: 0.04);
    for (var y = 100.0; y < size.height * 0.55; y += 90) {
      for (var x = 50.0; x < size.width; x += 70) {
        canvas.drawRRect(
          RRect.fromRectAndRadius(
            Rect.fromLTWH(x + 8, y + 8, 50, 60),
            const Radius.circular(6),
          ),
          block,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

class _Header extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final top = MediaQuery.of(context).padding.top;

    return Container(
      width: double.infinity,
      padding: EdgeInsets.fromLTRB(16, top + 8, 20, 22),
      decoration: const BoxDecoration(
        color: AppColors.primary,
        borderRadius: BorderRadius.vertical(bottom: Radius.circular(28)),
      ),
      child: Row(
        children: [
          GestureDetector(
            onTap: () => Get.back(),
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withValues(alpha: 0.12),
              ),
              child: const Icon(
                Icons.arrow_back_ios_new_rounded,
                color: Colors.white,
                size: 18,
              ),
            ),
          ),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Map view',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                  ),
                ),
                SizedBox(height: 2),
                Text(
                  'Sample map · hostels nearby',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.14),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.white.withValues(alpha: 0.2)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.map_rounded, size: 14, color: Colors.white),
                SizedBox(width: 5),
                Text(
                  'Sample',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar({required this.controller});
  final SeekerMapController controller;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: AppColors.surfaceWhite,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: AppColors.border),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.05),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.search_rounded,
              color: AppColors.accent,
              size: 22,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: TextField(
                style: const TextStyle(
                  color: AppColors.textPrimary,
                  fontSize: 15,
                ),
                cursorColor: AppColors.primary,
                onChanged: controller.onSearchChanged,
                decoration: const InputDecoration(
                  hintText: 'Search area or hostel...',
                  hintStyle: TextStyle(
                    color: AppColors.textMuted,
                    fontSize: 14,
                  ),
                  border: InputBorder.none,
                  isDense: true,
                  contentPadding: EdgeInsets.zero,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Filters extends StatelessWidget {
  const _Filters({required this.controller});
  final SeekerMapController controller;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: controller.filters.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (_, i) {
          final f = controller.filters[i];
          return Obx(() {
            final selected = controller.selectedFilter.value == f;
            return GestureDetector(
              onTap: () => controller.onFilterChanged(f),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: selected
                      ? AppColors.primary
                      : AppColors.surfaceWhite,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                    color: selected
                        ? AppColors.primary
                        : AppColors.border,
                  ),
                ),
                child: Text(
                  f,
                  style: TextStyle(
                    color: selected
                        ? Colors.white
                        : AppColors.textPrimary,
                    fontSize: 12,
                    fontWeight:
                        selected ? FontWeight.w700 : FontWeight.w500,
                  ),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}

class _BottomSheet extends StatelessWidget {
  const _BottomSheet({required this.controller});
  final SeekerMapController controller;

  @override
  Widget build(BuildContext context) {
    final bottomPad = MediaQuery.of(context).padding.bottom;

    return Container(
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.40,
      ),
      decoration: BoxDecoration(
        color: AppColors.surfaceWhite,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(24)),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary.withValues(alpha: 0.1),
            blurRadius: 24,
            offset: const Offset(0, -8),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const SizedBox(height: 10),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.border,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: Row(
              children: [
                const Text(
                  'Nearby hostels',
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const Spacer(),
                Obx(
                  () => Text(
                    '${controller.filtered.length} found',
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 12,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          Flexible(
            child: Obx(() {
              final list = controller.filtered;
              if (list.isEmpty) {
                return const Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                    'No hostels found',
                    style: TextStyle(color: AppColors.textSecondary),
                  ),
                );
              }
              return ListView.separated(
                padding: EdgeInsets.fromLTRB(16, 0, 16, 16 + bottomPad),
                shrinkWrap: true,
                itemCount: list.length,
                separatorBuilder: (_, __) => const SizedBox(height: 10),
                itemBuilder: (_, i) {
                  final h = list[i];
                  final selected = controller.selectedHostel.value == h;
                  return GestureDetector(
                    onTap: () => controller.onHostelTap(h),
                    child: Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: selected
                            ? AppColors.accent.withValues(alpha: 0.1)
                            : AppColors.surfaceSoft,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: selected
                              ? AppColors.accent
                              : AppColors.border,
                        ),
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 44,
                            height: 44,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              color: AppColors.primary,
                            ),
                            child: const Icon(
                              Icons.star_rounded,
                              color: Colors.white,
                              size: 22,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  h['name']?.toString() ?? '',
                                  style: const TextStyle(
                                    color: AppColors.textPrimary,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                const SizedBox(height: 3),
                                Text(
                                  '${h['area']}, ${h['city']} · ${h['distance']}',
                                  style: const TextStyle(
                                    color: AppColors.textSecondary,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text(
                                h['price']?.toString() ?? '',
                                style: const TextStyle(
                                  color: AppColors.primary,
                                  fontSize: 13,
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                              const SizedBox(height: 2),
                              Row(
                                children: [
                                  const Icon(
                                    Icons.star_rounded,
                                    size: 13,
                                    color: Color(0xFFFFC107),
                                  ),
                                  const SizedBox(width: 2),
                                  Text(
                                    '${h['rating']}',
                                    style: const TextStyle(
                                      color: AppColors.textSecondary,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}