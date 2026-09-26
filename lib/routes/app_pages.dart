import 'package:get/get.dart';

import '../presentation/auth/bindings/auth_binding.dart';
import '../presentation/auth/views/auth_view.dart';
import '../presentation/profile_setup/bindings/profile_setup_binding.dart';
import '../presentation/profile_setup/views/profile_setup_view.dart';
import '../presentation/splash/bindings/splash_binding.dart';
import '../presentation/splash/views/splash_view.dart';
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
    GetPage(
      name: AppRoutes.profileSetup,
      page: () => const ProfileSetupView(),
      binding: ProfileSetupBinding(),
    ),
  ];
}
