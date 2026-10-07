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
import '../presentation/seeker_bids/bindings/seeker_bids_binding.dart';
import '../presentation/seeker_bids/views/seeker_bids_view.dart';
import '../presentation/seeker_search/bindings/seeker_search_binding.dart';
import '../presentation/seeker_search/views/seeker_search_view.dart';
import '../presentation/seeker_bids/views/bid_detail_view.dart';
import '../presentation/place_bid/bindings/place_bid_binding.dart';
import '../presentation/place_bid/views/place_bid_view.dart';
import '../presentation/seeker_map/bindings/seeker_map_binding.dart';
import '../presentation/seeker_map/views/seeker_map_view.dart';
import '../presentation/notifications/bindings/notifications_binding.dart';
import '../presentation/notifications/views/notifications_view.dart';
import '../presentation/manager_incoming_bids/bindings/manager_incoming_bids_binding.dart';
import '../presentation/manager_incoming_bids/views/manager_incoming_bids_view.dart';
import '../presentation/manager_rooms/bindings/manager_rooms_binding.dart';
import '../presentation/seeker_search/views/details_view.dart';
import '../presentation/manager_rooms/views/manager_rooms_view.dart';

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
    GetPage(
      name: AppRoutes.seekerBids,
      page: () => const SeekerBidsView(),
      binding: SeekerBidsBinding(),
    ),
    GetPage(
      name: AppRoutes.seekerSearch,
      page: () => const SeekerSearchView(),
      binding: SeekerSearchBinding(),
    ),
    GetPage(
      name: AppRoutes.placeBid,
      page: () => const PlaceBidView(),
      binding: PlaceBidBinding(),
    ),

    GetPage(
      name: AppRoutes.seekerMap,
      page: () => const SeekerMapView(),
      binding: SeekerMapBinding(),
    ),
    GetPage(
  name: AppRoutes.seekerMyBidDetail,
  page: () => const BidDetailView(),
),
    GetPage(
  name: AppRoutes.notifications,
  page: () => const NotificationsView(),
  binding: NotificationsBinding(),
),
GetPage(
  name: AppRoutes.managerIncomingBids,
  page: () => const ManagerIncomingBidsView(),
  binding: ManagerIncomingBidsBinding(),
),
GetPage(
  name: AppRoutes.managerRooms,
  page: () => const ManagerRoomsView(),
  binding: ManagerRoomsBinding(),
),
GetPage(
  name: AppRoutes.hostelDetails,
  page: () => const DetailsView(),
),
  ];
}
