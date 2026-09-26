import 'package:get/get.dart';

import '../presentation/auth/bindings/auth_binding.dart';
import '../presentation/auth/views/auth_view.dart';
import '../presentation/splash/bindings/splash_binding.dart';
import '../presentation/splash/views/splash_view.dart';
import 'app_routes.dart';

/// GetX page registry. Add a GetPage entry here for every screen
/// as it gets built so navigation (Get.toNamed / Get.offNamed) works.
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.auth,
      page: () => const AuthView(),
      binding: AuthBinding(),
    ),
  ];
}