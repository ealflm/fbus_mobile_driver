import 'package:get/get.dart';

import '../controllers/swap_controller.dart';

class SwapBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SwapController>(
      () => SwapController(),
    );
  }
}
