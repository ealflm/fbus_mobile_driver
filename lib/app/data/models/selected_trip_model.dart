import 'package:get/get.dart';
import 'package:latlong2/latlong.dart';

import '../../core/base/base_controller.dart';
import '../../core/widget/shared.dart';
import 'direction_model.dart';
import 'route_model.dart';
import 'station_model.dart';
import 'trip_model.dart';

class SelectedTrip extends BaseController {
  // Selected route
  final Rx<Route?> _selectedRoute = Rx<Route?>(null);
  Route? get selectedRoute => _selectedRoute.value;
  set selectedRoute(Route? value) {
    _selectedRoute.value = value;
  }

  // Selected trip
  final Rx<Trip?> _selectedTrip = Rx<Trip?>(null);
  Trip? get selectedTrip => _selectedTrip.value;
  set selectedTrip(Trip? value) {
    _selectedTrip.value = value;
  }

  // Selected station
  final Rx<Station?> _selectedStation = Rx<Station?>(null);
  Station? get selectedStation => _selectedStation.value;
  set selectedStation(Station? value) {
    _selectedStation.value = value;
  }

  // Start station
  final Rx<Station?> _startStation = Rx<Station?>(null);
  Station? get startStation => _startStation.value;
  set startStation(Station? value) {
    _startStation.value = value;
  }

  // End station
  final Rx<Station?> _endStation = Rx<Station?>(null);
  Station? get endStation => _endStation.value;
  set endStation(Station? value) {
    _endStation.value = value;
  }

  // Points
  final Rx<List<LatLng>?> _points = Rx<List<LatLng>?>(null);
  List<LatLng>? get points => _points.value;
  set points(List<LatLng>? value) {
    _points.value = value;
  }

  // Start time
  final Rx<DateTime?> _startTime = Rx<DateTime?>(null);
  DateTime? get startTime => _startTime.value;
  set startTime(DateTime? value) {
    _startTime.value = value;
  }

  // End time
  final Rx<DateTime?> _endTime = Rx<DateTime?>(null);
  DateTime? get endTime => _endTime.value;
  set endTime(DateTime? value) {
    _endTime.value = value;
  }

  // Distance
  final Rx<double> _distance = Rx<double>(0);
  double get distance => _distance.value;
  set distance(double value) {
    _distance.value = value;
  }

  // Duration
  final Rx<Duration?> _duration = Rx<Duration?>(null);
  Duration? get duration => _duration.value;
  set duration(Duration? value) {
    _duration.value = value;
  }

  // Type
  // True: from home to school
  // False: from school to home
  bool? get type {
    if (endStation != null) {
      return true;
    } else {
      return false;
    }
  }

  // stations
  List<Station> stations = [];

  void updatePoints(Function() screenAnimation) async {
    updateStations();

    clearPoints();

    if (selectedStation != null) {
      await fetchPoints();
      screenAnimation();
    }
  }

  void updateStations() {
    List<Station> result = [];

    List<Station> stationList = selectedRoute?.stations ?? [];

    if (stationList.isEmpty || selectedStation == null) return;

    if (startStation != null) {
      int n = 0;
      while (n < stationList.length) {
        if (selectedStation?.id == stationList[n++].id) {
          break;
        }
      }

      for (int i = 0; i < n; i++) {
        result.add(stationList[i]);
      }
    } else if (endStation != null) {
      int i = 0;
      while (i < stationList.length) {
        if (selectedStation?.id == stationList[i].id) {
          break;
        }
        i++;
      }

      for (; i < stationList.length; i++) {
        result.add(stationList[i]);
      }
    }

    stations = result;
  }

  Future<void> fetchPoints() async {
    List<LatLng> locations = [];

    for (Station station in stations) {
      if (station.location != null) {
        locations.add(station.location!);
      }
    }

    if (locations.isEmpty) return;

    var pointsService = goongRepository.getDirection(locations);

    await callDataService(
      pointsService,
      onSuccess: (Direction? response) {
        if (response != null) {
          distance = response.distance ?? 0;
          duration = response.duration;
          points = response.points;
        }
      },
      onError: ((exception) {
        showToast('Không thể kết nối');
      }),
    );
  }

  void clearPoints() {
    points = [];
  }

  void clearSelection() {
    selectedStation = null;
    points = [];
  }
}
