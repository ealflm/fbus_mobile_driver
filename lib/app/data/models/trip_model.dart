import 'package:intl/intl.dart';

import '../../core/utils/utils.dart';
import 'bus_model.dart';
import 'driver_model.dart';
import 'route_model.dart';
import 'selected_trip_model.dart';
import 'station_model.dart';

class Trip {
  String? id;
  Bus? bus;
  Driver? driver;
  Route? route;
  DateTime? date;
  Duration? startTime;
  Duration? endTime;
  double? rate;
  int? status;

  Route? selectedRoute;
  Station? selectedStation;
  Station? startStation;
  Station? endStation;
  double? distance;
  Duration? estimatedTime;

  Station? get fromStation {
    if (startStation != null) {
      return startStation;
    } else {
      return selectedStation;
    }
  }

  Station? get toStation {
    if (endStation != null) {
      return endStation;
    } else {
      return selectedStation;
    }
  }

  DateTime? get startTimeEstimated {
    if (startTime == null || date == null) return null;
    if (endStation != null && estimatedTime != null) {
      return date!.add(endTime!).subtract(estimatedTime!);
    }
    return date!.add(startTime!);
  }

  DateTime? get endTimeEstimated {
    if (endTime == null || date == null) return null;
    if (startStation != null && estimatedTime != null) {
      return date!.add(startTime!).add(estimatedTime!);
    }
    return date!.add(endTime!);
  }

  String get startTimeStr {
    if (startTime == null) return '-';
    if (endStation != null && estimatedTime != null) {
      return DateFormat('HH:mm')
          .format(DateTime(1, 1, 1).add(endTime!).subtract(estimatedTime!));
    }
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(startTime!));
  }

  String get endTimeStr {
    if (endTime == null) return '-';
    if (startStation != null && estimatedTime != null) {
      return DateFormat('HH:mm')
          .format(DateTime(1, 1, 1).add(startTime!).add(estimatedTime!));
    }
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(endTime!));
  }

  String get distanceStr {
    if (distance != null) {
      double value = distance! / 1000;
      return value.toStringAsFixed(1);
    } else {
      return '-';
    }
  }

  String get estimatedTimeStr {
    return formatDurationOnlyHourMinite(estimatedTime);
  }

  String get dateStr {
    if (date == null) return '-';
    return DateFormat('dd/MM/yyyy').format(date!);
  }

  Trip({
    this.id,
    this.bus,
    this.driver,
    this.route,
    this.date,
    this.startTime,
    this.endTime,
    this.rate,
    this.status,
  });

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['tripId'];
    bus = Bus.fromJson(json['bus']);
    driver = Driver.fromJson(json['driver']);
    route = Route.fromJson(json['route']);
    date = DateTime.parse(json['date']);
    startTime = parseDuration(json['timeStart']);
    endTime = parseDuration(json['timeEnd']);
    if (json['rate'] != null) {
      rate = 0.0 + json['rate'];
    }
    status = json['status'];
  }

  void mapSelectedTrip(SelectedTrip selectedTrip) {
    selectedRoute = selectedTrip.selectedRoute;
    selectedStation = selectedTrip.selectedStation;
    startStation = selectedTrip.startStation;
    endStation = selectedTrip.endStation;
    distance = selectedTrip.distance;
    estimatedTime = selectedTrip.duration;
  }
}
