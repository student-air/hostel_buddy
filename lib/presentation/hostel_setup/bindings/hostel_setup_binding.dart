import 'package:get/get.dart';

import '../controllers/hostel_setup_controller.dart';

class HostelSetupBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<HostelSetupController>(() => HostelSetupController());
  }
}
