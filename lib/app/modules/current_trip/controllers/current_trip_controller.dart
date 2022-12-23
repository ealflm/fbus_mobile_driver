import 'package:get/get.dart';

import '../../map/hyper_map_controller.dart';

class CurrentTripController extends GetxController {
  HyperMapController hyperMapController = HyperMapController();

  void onMapReady() async {
    await hyperMapController.refreshCurrentLocation();
    await Future.delayed(const Duration(milliseconds: 800));
    hyperMapController.moveToCurrentLocation();
  }
}
