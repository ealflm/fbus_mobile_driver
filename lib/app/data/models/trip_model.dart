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

  Trip.fromJson(Map<String, dynamic> json) {
    id = json['tripId'];
    bus = Bus.fromJson(json['bus']);
    driver = Driver.fromJson(json['driver']);
    route = Route.fromJson(json['route']);
    date = json['date'];
    timeStart = parseDuration(json['timeStart']);
    timeEnd = parseDuration(json['timeEnd']);
    status = json['status'];
    rate = json['rate'];
  }
}
