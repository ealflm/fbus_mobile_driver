import 'package:get/get.dart';

import '../controllers/select_trip_controller.dart';

class SelectTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectTripController>(
      () => SelectTripController(),
    );
  }
}
