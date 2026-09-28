import 'package:get/get.dart';
import '../controllers/place_bid_controller.dart';

class PlaceBidBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PlaceBidController>(() => PlaceBidController());
  }
}