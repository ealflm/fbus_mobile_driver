import 'package:latlong2/latlong.dart';

import 'station_model.dart';

class Route {
  String? id;
  String? name;
  double? distance;
  List<Station>? stations;
  List<LatLng>? points;

  String get distanceStr {
    if (distance != null) {
      double value = distance! / 1000;
      return value.toStringAsFixed(1);
    } else {
      return '-';
    }
  }

  // Convert station list to list of station location
  List<LatLng> get stationLocations {
    List<LatLng> result = [];
    for (Station station in stations!) {
      if (station.location == null) continue;
      result.add(station.location!);
    }
    return result;
  }

  Route({
    this.id,
    this.name,
    this.distance,
    this.stations,
    this.points,
  });

  Route.fromJson(Map<String, dynamic> json) {
    id = json['routeId'];
    name = json['name'];
    distance = json['distance'];
    if (json['stationList'] != null) {
      stations = <Station>[];
      json['stationList'].forEach((value) {
        stations?.add(Station.fromJson(value));
      });
    }
  }

  Route.fromJsonCapitalizeFirstLetter(Map<String, dynamic> json) {
    id = json['RouteId'];
    name = json['Name'];
    distance = json['Distance'];
    if (json['StationList'] != null) {
      stations = <Station>[];
      json['StationList'].forEach((value) {
        stations?.add(Station.fromJsonCapitalizeFirstLetter(value));
      });
    }
  }
}
