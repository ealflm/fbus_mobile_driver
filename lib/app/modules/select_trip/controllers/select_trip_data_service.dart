import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/widget/shared.dart';
import '../../../data/models/selected_trip_model.dart';
import '../../../data/models/trip_model.dart';

class SelectTripDataService extends BaseController {
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  // Trip
  final Rx<List<Trip>?> _trips = Rx<List<Trip>?>(null);
  List<Trip>? get trips => _trips.value;
  set trips(List<Trip>? value) {
    _trips.value = value;
  }

  Future<void> fetchTrip(
      String routeId, DateTime date, SelectedTrip selectedTrip) async {
    isLoading = true;
    trips = [];
    var tripService = repository.getTrip(routeId, date, selectedTrip);

    await callDataService(
      tripService,
      onSuccess: (List<Trip> response) {
        trips = response;
      },
      onError: (exception) {
        showToast('Không thể kết nối');
      },
    );
    isLoading = false;
  }
}
