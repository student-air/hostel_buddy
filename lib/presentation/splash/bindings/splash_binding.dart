<<<<<<< HEAD
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    // Use put (not lazyPut) so the controller starts immediately
    Get.put(SplashController());
  }
}
=======
import 'package:get/get.dart';

import '../controllers/splash_controller.dart';

class SplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SplashController>(() => SplashController());
  }
}
>>>>>>> 2b2b7bd932c73d39269a25b1e29c86fedef37cb2
