import 'package:get/get.dart';

import '../controllers/seeker_bids_controller.dart';

class SeekerBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeekerBidsController>(() => SeekerBidsController());
  }
}
