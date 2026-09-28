import 'package:get/get.dart';
import '../controllers/seeker_search_controller.dart';

class SeekerSearchBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SeekerSearchController>(() => SeekerSearchController());
  }
}