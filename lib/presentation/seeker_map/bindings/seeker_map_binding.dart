import 'package:get/get.dart';
import '../controllers/seeker_map_controller.dart';

class SeekerMapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeekerMapController>(() => SeekerMapController());
  }
}