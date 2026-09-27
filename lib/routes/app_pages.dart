import 'package:get/get.dart';

import '../presentation/auth/bindings/auth_binding.dart';
import '../presentation/auth/views/auth_view.dart';
import '../presentation/profile_setup/bindings/profile_setup_binding.dart';
import '../presentation/profile_setup/views/profile_setup_view.dart';
import '../presentation/splash/bindings/splash_binding.dart';
import '../presentation/splash/views/splash_view.dart';
import '../presentation/role_selection/bindings/role_selection_binding.dart';
import '../presentation/role_selection/views/role_selection_view.dart';
import '../presentation/hostel_setup/bindings/hostel_setup_binding.dart';
import '../presentation/hostel_setup/views/hostel_setup_view.dart';
import '../presentation/seeker_home/bindings/seeker_home_binding.dart';
import '../presentation/seeker_home/views/seeker_home_view.dart';
import '../presentation/manager_home/bindings/manager_home_binding.dart';
import '../presentation/manager_home/views/manager_home_view.dart';
import '../presentation/profile/bindings/profile_binding.dart';
import '../presentation/profile/views/profile_view.dart';

// in pages list

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
    GetPage(
      name: AppRoutes.roleSelection,
      page: () => const RoleSelectionView(),
      binding: RoleSelectionBinding(),
    ),
    GetPage(
      name: AppRoutes.hostelSetup,
      page: () => const HostelSetupView(),
      binding: HostelSetupBinding(),
    ),
    GetPage(
      name: AppRoutes.seekerHome,
      page: () => const SeekerHomeView(),
      binding: SeekerHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.managerHome,
      page: () => const ManagerHomeView(),
      binding: ManagerHomeBinding(),
    ),
    GetPage(
      name: AppRoutes.profile,
      page: () => const ProfileView(),
      binding: ProfileBinding(),
    ),
  ];
}
