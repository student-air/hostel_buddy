import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use put (not lazyPut) so the controller starts immediately
    Get.put(SplashController());
  }
}
