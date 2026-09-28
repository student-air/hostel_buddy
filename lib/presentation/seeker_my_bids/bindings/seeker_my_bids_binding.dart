import 'package:get/get.dart';

import '../controllers/seeker_my_bids_controller.dart';

class SeekerMyBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeekerMyBidsController>(
      () => SeekerMyBidsController(),
      fenix: true, // recreate if needed, still loads from storage
    );
  }
}