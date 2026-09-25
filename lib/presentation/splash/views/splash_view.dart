import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/constants/app_colors.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/constants/app_dimens.dart';
import '../../../core/constants/app_text_styles.dart';
import '../controllers/splash_controller.dart';

class SplashView extends GetView<SplashController> {
  const SplashView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(gradient: AppColors.primaryGradient),
        child: SafeArea(
          child: Column(
            children: [
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: AppDimens.avatarLarge,
                      height: AppDimens.avatarLarge,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.18),
                        borderRadius: BorderRadius.circular(
                          AppDimens.radiusXLarge + 10,
                        ),
                        border: Border.all(
                          color: Colors.white.withValues(alpha: 0.35),
                        ),
                      ),
                      child: const Icon(
                        Icons.home_rounded,
                        size: 48,
                        color: Colors.white,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space22),
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.splashTitle,
                    ),
                    const SizedBox(height: AppDimens.space6),
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.splashSubtitle,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(bottom: 56),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _Dot(width: 22, active: true),
                    const SizedBox(width: AppDimens.space6),
                    _Dot(width: 6, active: false),
                    const SizedBox(width: AppDimens.space6),
                    _Dot(width: 6, active: false),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Dot extends StatelessWidget {
  const _Dot({required this.width, required this.active});

  final double width;
  final bool active;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: 6,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: active ? 1 : 0.45),
        borderRadius: BorderRadius.circular(3),
      ),
    );
  }
}
