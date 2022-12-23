import 'package:get/get.dart';

import '../../../core/base/base_controller.dart';
import '../../../core/widget/shared.dart';
import '../../../data/models/route_model.dart';
import '../../../data/models/selected_trip_model.dart';
import '../../../data/models/station_model.dart';

class RouteDataService extends BaseController {
  // Loading
  final Rx<bool> _isLoading = Rx<bool>(false);
  bool get isLoading => _isLoading.value;
  set isLoading(bool value) {
    _isLoading.value = value;
  }

  // Routes
  final Rx<Map<String, Route>> _routes = Rx<Map<String, Route>>({});
  Map<String, Route> get routes => _routes.value;
  set routes(Map<String, Route> value) {
    _routes.value = value;
  }

  // Selected route
  final _selectedRouteId = ''.obs;
  String get selectedRouteId => _selectedRouteId.value;
  set selectedRouteId(String value) {
    _selectedRouteId.value = value;

    // Selected trip
    selectedTrip.selectedRoute = routes[_selectedRouteId.value];
    selectedTrip.startStation = startStation;
    selectedTrip.endStation = endStation;
  }

  Route? get selectedRoute {
    return routes[_selectedRouteId.value];
  }

  // Start station
  Station? get startStation {
    if (selectedRoute == null) return null;

    List<Station> stations = selectedRoute?.stations ?? [];

    if (stations.isEmpty) return null;

    if (stations.first.name?.toLowerCase().contains('fpt') ?? false) {
      return stations.first;
    }
    return null;
  }

  // End station
  Station? get endStation {
    if (selectedRoute == null) return null;

    List<Station> stations = selectedRoute?.stations ?? [];

    if (stations.isEmpty) return null;

    if (stations.last.name?.toLowerCase().contains('fpt') ?? false) {
      return stations.last;
    }
    return null;
  }

  // Stations
  final Rx<Map<String, Station>> _stations = Rx<Map<String, Station>>({});
  Map<String, Station> get stations => _stations.value;
  set stations(Map<String, Station> value) {
    _stations.value = value;
  }

  // Selected station
  final _selectedStationId = ''.obs;
  String get selectedStationId => _selectedStationId.value;
  set selectedStationId(String value) {
    _selectedStationId.value = value;

    // Selected trip
    selectedTrip.selectedStation = stations[_selectedStationId.value];
  }

  Station? get selectedStation {
    return stations[_selectedStationId.value];
  }

  // Selected trip
  SelectedTrip selectedTrip = SelectedTrip();

  Future<void> fetchRoutes() async {
    isLoading = true;
    var routesService = repository.getRoute();

    await callDataService(
      routesService,
      onSuccess: (List<Route> response) {
        routes = routeListToRouteMap(response);
        stations = routeListToStationMap(response);
        if (routes.isNotEmpty && routes.values.first.id != null) {
          selectedRouteId = routes.values.first.id!;
        }
      },
      onError: ((exception) {
        showToast('Không thể kết nối');
      }),
    );
    isLoading = false;
  }

  Map<String, Route> routeListToRouteMap(List<Route> value) {
    Map<String, Route> result = {};
    for (Route route in value) {
      if (route.id != null) {
        result[route.id!] = route;
      }
    }
    return result;
  }

  Map<String, Station> routeListToStationMap(List<Route> value) {
    Map<String, Station> result = {};
    for (Route route in value) {
      if (route.id != null && route.stations != null) {
        for (Station station in route.stations!) {
          if (station.id != null) {
            result[station.id!] = station;
          }
        }
      }
    }
    return result;
  }

  void selectRoute(String id) {
    selectedRouteId = id;
  }

  void selectStation(String id) {
    selectedStationId = id;
  }
}
