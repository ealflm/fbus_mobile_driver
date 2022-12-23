import 'package:get/get.dart';

import '../controllers/select_route_controller.dart';

class SelectRouteBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectRouteController>(
      () => SelectRouteController(),
    );
  }
}
