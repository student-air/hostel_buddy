import 'package:get/get.dart';

import '../controllers/manager_incoming_bids_controller.dart';

class ManagerIncomingBidsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerIncomingBidsController>(
      () => ManagerIncomingBidsController(),
    );
  }
}