import 'package:get/get.dart';

import 'main_controller.dart';

class MainBinding extends Bindings {
  @override
  void dependencies() {
    return Get.lazyPut(() => MainController());
  }
}
