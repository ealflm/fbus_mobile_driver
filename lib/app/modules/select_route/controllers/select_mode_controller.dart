import 'package:get/get.dart';

import '../../../data/models/selected_trip_model.dart';
import '../../../routes/app_pages.dart';

class SelectModeController {
  final Rx<SelectMode> _mode = Rx<SelectMode>(SelectMode.route);
  SelectMode get mode => _mode.value;
  set mode(SelectMode value) {
    _mode.value = value;
  }

  void next(SelectedTrip selectedTrip) {
    if (mode == SelectMode.route) {
      mode = SelectMode.station;
    } else if (mode == SelectMode.station) {
      Get.toNamed(Routes.SELECT_TRIP,
          arguments: {'selectedTrip': selectedTrip});
    }
  }

  void back() {
    if (mode == SelectMode.station) {
      mode = SelectMode.route;
    }
  }

  bool canBack() {
    return mode == SelectMode.station;
  }
}

enum SelectMode {
  route,
  station,
}
