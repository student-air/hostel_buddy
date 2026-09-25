import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

/// Shows the splash screen briefly, then moves on.
/// Once auth/session data exists, this is where you'd check for a
/// logged-in user and skip straight past Auth — for now it always
/// routes to Auth after the delay.
class SplashController extends GetxController {
  static const Duration displayDuration = Duration(seconds: 2);

  @override
  void onInit() {
    super.onInit();
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(displayDuration);
    Get.offNamed(AppRoutes.auth);
  }
}
