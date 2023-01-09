import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../data/models/trip_model.dart';

class HomeTripDataService extends BaseController {
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final Rx<Trip?> _trip = Rx<Trip?>(null);
  Trip? get trip => _trip.value;
  set trip(Trip? value) {
    _trip.value = value;
  }

  @override
  void onInit() {
    fetchTrip();
    super.onInit();
  }

  Future<void> fetchTrip() async {
    isLoading = true;
    String driverId = AuthService.driver?.id ?? '';
    var fetchTripService = repository.getCurrentTrip(driverId);

    await callDataService(
      fetchTripService,
      onSuccess: (Trip? response) {
        trip = response;
      },
      onError: (exception) {},
    );
    isLoading = false;
  }
}
