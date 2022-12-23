import 'package:get/get.dart';

import '../controllers/current_trip_controller.dart';

class CurrentTripBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CurrentTripController>(
      () => CurrentTripController(),
    );
  }
}
