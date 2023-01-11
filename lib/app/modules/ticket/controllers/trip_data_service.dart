import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/utils/auth_service.dart';
import '../../../data/models/trip_model.dart';

class TripDataService extends BaseController {
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  final Rx<List<Trip>?> _futureTrips = Rx<List<Trip>?>(null);
  List<Trip>? get futureTrips => _futureTrips.value;
  set futureTrips(List<Trip>? value) {
    _futureTrips.value = value;
  }

  final Rx<List<Trip>?> _pastTrips = Rx<List<Trip>?>(null);
  List<Trip>? get pastTrips => _pastTrips.value;
  set pastTrips(List<Trip>? value) {
    _pastTrips.value = value;
  }

  @override
  void onInit() {
    fetch();
    super.onInit();
  }

  Future<void> fetch() async {
    isLoading = true;
    await fetchFutureTrips();
    await fetchPastTrips();
    isLoading = false;
  }

  Future<void> fetchFutureTrips() async {
    String driverId = AuthService.driver?.id ?? '';
    var fetchFutureTripsService = repository.getFutureTrips(driverId);

    await callDataService(
      fetchFutureTripsService,
      onSuccess: (List<Trip> response) {
        futureTrips = response;
        futureTrips?.sort((a, b) {
          if (a.startDate == null || b.startDate == null) return -1;
          return a.startDate!.compareTo(b.startDate!);
        });
      },
      onError: (exception) {},
    );
  }

  Future<void> fetchPastTrips() async {
    String driverId = AuthService.driver?.id ?? '';
    var fetchPastTripsService = repository.getPastTrips(driverId);

    await callDataService(
      fetchPastTripsService,
      onSuccess: (List<Trip> response) {
        pastTrips = response;
        pastTrips?.sort((b, a) {
          if (a.startDate == null || b.startDate == null) return -1;
          return a.startDate!.compareTo(b.startDate!);
        });
      },
      onError: (exception) {},
    );
  }
}
