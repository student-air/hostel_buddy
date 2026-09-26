import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.light,
      child: Scaffold(
        body: Stack(
          children: [
            // Background gradient
            Container(
              width: double.infinity,
              height: double.infinity,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Color(0xFF6B0E24),
                    Color(0xFF4A0A1E),
                    Color(0xFF3C0515),
                    Color(0xFF2A0412),
                  ],
                  stops: [0.0, 0.35, 0.7, 1.0],
                ),
              ),
            ),

            // Decorative circles
            Positioned(
              top: -50,
              right: -70,
              child: _DecorCircle(
                size: 240,
                color: Colors.white.withValues(alpha: 0.04),
              ),
            ),
            Positioned(
              top: 100,
              right: -20,
              child: _DecorCircle(
                size: 160,
                color: const Color(0xFF2A1840).withValues(alpha: 0.4),
              ),
            ),
            Positioned(
              bottom: 120,
              left: -90,
              child: _DecorCircle(
                size: 220,
                color: Colors.white.withValues(alpha: 0.03),
              ),
            ),
            Positioned(
              bottom: -30,
              right: 30,
              child: _DecorCircle(
                size: 150,
                color: AppColors.accent.withValues(alpha: 0.08),
              ),
            ),

            // Content — centered
            SafeArea(
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const _AnimatedLogo(),
                    const SizedBox(height: AppDimens.space24),
                    Text(
                      AppConstants.appName,
                      style: AppTextStyles.splashTitle.copyWith(
                        fontWeight: FontWeight.w700,
                        letterSpacing: -0.4,
                      ),
                    ),
                    const SizedBox(height: AppDimens.space8),
                    Text(
                      AppConstants.appTagline,
                      style: AppTextStyles.splashSubtitle.copyWith(
                        color: Colors.white.withValues(alpha: 0.7),
                      ),
                    ),
                    const SizedBox(height: AppDimens.space32),
                    const _PulsingDotsLoader(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Animated logo (gentle scale pulse)
// ─────────────────────────────────────────────

class _AnimatedLogo extends StatefulWidget {
  const _AnimatedLogo();

  @override
  State<_AnimatedLogo> createState() => _AnimatedLogoState();
}

class _AnimatedLogoState extends State<_AnimatedLogo>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;
  late final Animation<double> _scale;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    )..repeat(reverse: true);

    _scale = Tween<double>(
      begin: 1.0,
      end: 1.06,
    ).animate(CurvedAnimation(parent: _controller, curve: Curves.easeInOut));
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ScaleTransition(
      scale: _scale,
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.25),
              blurRadius: 24,
              offset: const Offset(0, 10),
            ),
            BoxShadow(
              color: AppColors.accent.withValues(alpha: 0.3),
              blurRadius: 28,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: Image.asset(
          'assets/images/app_logo.png',
          fit: BoxFit.cover,
          errorBuilder: (_, __, ___) => const Icon(
            Icons.home_rounded,
            size: 48,
            color: AppColors.primary,
          ),
        ),
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Pulsing dots loader (teal)
// ─────────────────────────────────────────────

class _PulsingDotsLoader extends StatefulWidget {
  const _PulsingDotsLoader();

  @override
  State<_PulsingDotsLoader> createState() => _PulsingDotsLoaderState();
}

class _PulsingDotsLoaderState extends State<_PulsingDotsLoader>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return Row(
          mainAxisSize: MainAxisSize.min,
          children: List.generate(3, (index) {
            final delay = index * 0.2;
            final t = (_controller.value - delay) % 1.0;
            final bounce = t < 0.5
                ? Curves.easeOut.transform(t * 2)
                : Curves.easeIn.transform(1 - (t - 0.5) * 2);

            final scale = 0.55 + (bounce * 0.45);
            final opacity = 0.35 + (bounce * 0.65);

            return Padding(
              padding: EdgeInsets.only(right: index < 2 ? 8 : 0),
              child: Transform.scale(
                scale: scale,
                child: Opacity(
                  opacity: opacity.clamp(0.0, 1.0),
                  child: Container(
                    width: 10,
                    height: 10,
                    decoration: BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: AppColors.accent.withValues(
                            alpha: 0.45 * bounce,
                          ),
                          blurRadius: 8,
                          spreadRadius: 1,
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }),
        );
      },
    );
  }
}

// ─────────────────────────────────────────────
// Decor circle
// ─────────────────────────────────────────────

class _DecorCircle extends StatelessWidget {
  const _DecorCircle({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(shape: BoxShape.circle, color: color),
    );
  }
}
