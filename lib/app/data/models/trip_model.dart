import 'package:intl/intl.dart';

import '../../core/utils/utils.dart';
import 'bus_model.dart';
import 'driver_model.dart';
import 'route_model.dart';

class Trip {
  String? id;
  Bus? bus;
  Driver? driver;
  Route? route;
  DateTime? date;
  Duration? timeStart;
  Duration? timeEnd;
  int? status;
  num? rate;
  String? title;

  String get dateStr {
    if (date == null) return '';
    return DateFormat('dd/MM/yyyy').format(date!);
  }

  String get startTimeStr {
    if (timeStart == null) return '-';
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(timeStart!));
  }

  String get endTimeStr {
    if (timeEnd == null) return '-';
    return DateFormat('HH:mm').format(DateTime(1, 1, 1).add(timeEnd!));
  }

  String get estimatedTimeStr {
    if (timeEnd == null || timeStart == null) return '-';
    return formatDurationOnlyHourMinite(timeEnd! - timeStart!);
  }

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['tripId'];
    bus = Bus.fromJson(json['bus']);
    driver = Driver.fromJson(json['driver']);
    route = Route.fromJson(json['route']);
    date = DateTime.parse(json['date']);
    timeStart = parseDuration(json['timeStart']);
    timeEnd = parseDuration(json['timeEnd']);
    status = json['status'];
    rate = json['rate'];
  }
}
