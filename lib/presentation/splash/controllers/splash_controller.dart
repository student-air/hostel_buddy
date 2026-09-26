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
