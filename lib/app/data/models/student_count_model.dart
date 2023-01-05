import 'station_model.dart';

class StudentCount {
  Station? station;
  int? count;

  StudentCount({this.station, this.count});

  StudentCount.fromJson(Map<String, dynamic> json) {
    station = Station.fromJson(json['station']);
    count = json['count'];
  }
}
