import 'package:get/get.dart';
import 'package:demo/modules/map/map_controller.dart';

class MapBinding implements Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MapController>(() => MapController());
  }
}
