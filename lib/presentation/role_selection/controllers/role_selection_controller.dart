import 'package:get/get.dart';

import '../../../core/constants/app_constants.dart';
import '../../../core/utils/app_snackbar.dart';

/// Role selection: seeker or manager — nothing selected until user taps.
class RoleSelectionController extends GetxController {
  /// null until user selects; then AppConstants.roleSeeker | roleManager
  final selectedRole = RxnString();
  final isLoading = false.obs;

  void selectRole(String role) {
    selectedRole.value = role;
  }

  Future<void> continueNext() async {
    if (selectedRole.value == null) {
      AppSnackbar.warning(
        'Select a role',
        'Please choose how you will use HostelBuddy.',
      );
      return;
    }

    isLoading.value = true;
    await Future.delayed(const Duration(milliseconds: 400));
    isLoading.value = false;

    // TODO: Persist role and navigate to seeker/manager home
    final isSeeker = selectedRole.value == AppConstants.roleSeeker;
    AppSnackbar.success(
      'Role selected',
      isSeeker
          ? 'You are set up to find hostels'
          : 'You are set up to manage a hostel',
    );
  }

  void goBack() => Get.back();
}
