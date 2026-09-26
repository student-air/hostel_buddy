<<<<<<< HEAD
import 'package:get/get.dart';

import '../presentation/splash/bindings/splash_binding.dart';
import '../presentation/splash/views/splash_view.dart';
import '../presentation/auth/bindings/auth_binding.dart';
import '../presentation/auth/views/auth_view.dart';
import 'app_routes.dart';

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
=======
import 'package:get/get.dart';

import '../presentation/splash/bindings/splash_binding.dart';
import '../presentation/splash/views/splash_view.dart';
import 'app_routes.dart';

/// GetX page registry. Each screen gets appended here once it's built —
/// currently only Splash exists, so AppRoutes.auth isn't registered yet
/// (add its GetPage here as soon as the Auth screen is created).
class AppPages {
  AppPages._();

  static final List<GetPage> pages = [
    GetPage(
      name: AppRoutes.splash,
      page: () => const SplashView(),
      binding: SplashBinding(),
    ),
  ];
}
>>>>>>> 2b2b7bd932c73d39269a25b1e29c86fedef37cb2
