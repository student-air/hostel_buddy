import 'package:get/get.dart';
import '../controllers/manager_rooms_controller.dart';

class ManagerRoomsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ManagerRoomsController>(() => ManagerRoomsController());
  }
}