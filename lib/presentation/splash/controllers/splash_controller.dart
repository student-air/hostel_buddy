<<<<<<< HEAD
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

class SplashController extends GetxController {
  @override
  void onInit() {
    super.onInit();
    debugPrint('===== SPLASH CONTROLLER STARTED =====');
    _navigateAfterDelay();
  }

  Future<void> _navigateAfterDelay() async {
    await Future.delayed(const Duration(seconds: 2));
    debugPrint('Navigating to Auth...');
    Get.offNamed(AppRoutes.auth);
  }
}
=======
import 'package:get/get.dart';

import '../../../routes/app_routes.dart';

/// Shows the splash screen briefly, then navigates to Auth.
/// Later you can add session check logic here.
class SplashController extends GetxController {
  static const Duration displayDuration = Duration(seconds: 60);

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
>>>>>>> 2b2b7bd932c73d39269a25b1e29c86fedef37cb2
